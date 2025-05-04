library epubtest;

import 'package:test/test.dart';

import 'package:epubx/epub.dart';

main() {
  test("Enum One", () {
    expect(new EnumFromString<Simple>(Simple.values).get("ONE"),
        equals(Simple.ONE));
  });
  test("Enum Two", () {
    expect(new EnumFromString<Simple>(Simple.values).get("TWO"),
        equals(Simple.TWO));
  });
  test("Enum One", () {
    expect(new EnumFromString<Simple>(Simple.values).get("THREE"),
        equals(Simple.THREE));
  });
  test("Enum One Lower Case", () {
    expect(new EnumFromString<Simple>(Simple.values).get("one"),
        equals(Simple.ONE));
  });
}

enum Simple { ONE, TWO, THREE }
