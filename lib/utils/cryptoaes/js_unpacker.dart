import 'dart:math';

class JsUnpacker {
  static final RegExp _packedRegex = RegExp(
      r"eval[(]function[(]p,a,c,k,e,[r|d]?",
      caseSensitive: false,
      multiLine: true);

  static final RegExp _packedExtractRegex = RegExp(
      r"[}][(]'(.*)', *(\d+), *(\d+), *'(.*?)'[.]split[(]'[|]'[)]",
      caseSensitive: false,
      multiLine: true);

  static final RegExp _unpackReplaceRegex =
      RegExp(r"\b\w+\b", caseSensitive: false, multiLine: true);

  static bool detect(String scriptBlock) {
    return _packedRegex.hasMatch(scriptBlock);
  }

  static List<String> detectMultiple(List<String> scriptBlocks) {
    return scriptBlocks.where(detect).toList();
  }

  static List<String> unpack(String scriptBlock) {
    return detect(scriptBlock) ? _unpacking(scriptBlock).toList() : <String>[];
  }

  static String? unpackAndCombine(String scriptBlock) {
    final unpacked = unpack(scriptBlock);
    return unpacked.isEmpty ? null : unpacked.join(' ');
  }

  static Iterable<String> _unpacking(String scriptBlock) sync* {
    final matches = _packedExtractRegex.allMatches(scriptBlock);
    for (final match in matches) {
      final payload = match.group(1);
      final symtab = match.group(4)?.split('|');
      final radix = int.tryParse(match.group(2)!) ?? 10;
      final count = int.tryParse(match.group(3)!) ?? 0;
      final unbaser = Unbaser(radix);

      if (symtab != null && symtab.length == count) {
        final unpackedPayload =
            payload!.replaceAllMapped(_unpackReplaceRegex, (match) {
          final word = match.group(0)!;
          final unbased = symtab[unbaser.unbase(word)];
          return unbased.isEmpty ? word : unbased;
        });
        yield unpackedPayload;
      }
    }
  }
}

class Unbaser {
  final int base;
  static const Map<int, String> _alphabet = {
    52: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOP",
    54: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQR",
    62: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
    95: " !\"#\$%&\\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
  };

  Unbaser(this.base);

  int unbase(String value) {
    if (base >= 2 && base <= 36) {
      return int.tryParse(value, radix: base) ?? 0;
    } else {
      final dict = _alphabet[base]
          ?.split('')
          .asMap()
          .map((index, c) => MapEntry(c, index));
      var returnVal = 0;

      final valArray = value.runes.toList().reversed.toList();
      for (var i = 0; i < valArray.length; i++) {
        final cipher = String.fromCharCode(valArray[i]);
        returnVal += pow(base, i).toInt() * (dict?[cipher] ?? 0).toInt();
      }
      return returnVal;
    }
  }
}
