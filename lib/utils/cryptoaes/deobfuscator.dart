class Deobfuscator {
  static String deobfuscateJsPassword(String inputString) {
    int idx = 0;
    final brackets = ['[', '('];
    final evaluatedString = StringBuffer();

    while (idx < inputString.length) {
      final chr = inputString[idx];

      if (!brackets.contains(chr)) {
        idx++;
        continue;
      }

      final closingIndex = getMatchingBracketIndex(idx, inputString);

      if (chr == '[') {
        final digit = calculateDigit(inputString.substring(idx, closingIndex));
        evaluatedString.write(digit);
      } else {
        evaluatedString.write('.');

        if (inputString[closingIndex + 1] == '[') {
          final skippingIndex =
              getMatchingBracketIndex(closingIndex + 1, inputString);
          idx = skippingIndex + 1;
          continue;
        }
      }

      idx = closingIndex + 1;
    }

    return evaluatedString.toString();
  }

  static int getMatchingBracketIndex(int openingIndex, String inputString) {
    final openingBracket = inputString[openingIndex];
    final closingBracket = openingBracket == '[' ? ']' : ')';
    var counter = 0;

    for (var idx = openingIndex; idx < inputString.length; idx++) {
      if (inputString[idx] == openingBracket) counter++;
      if (inputString[idx] == closingBracket) counter--;

      if (counter == 0) return idx; // found matching bracket
      if (counter < 0) return -1; // unbalanced brackets
    }

    return -1; // matching bracket not found
  }

  static String calculateDigit(String inputSubString) {
    final digit = RegExp(r"\!\+\[\]").allMatches(inputSubString).length;

    if (digit == 0) {
      if (RegExp(r"\+\[\]").allMatches(inputSubString).length == 1) {
        return '0';
      }
    } else if (digit >= 1 && digit <= 9) {
      return digit.toString();
    }

    return '-'; // Illegal digit
  }
}
