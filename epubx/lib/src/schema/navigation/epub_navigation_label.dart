class EpubNavigationLabel {
  String? Text;

  @override
  int get hashCode => Text.hashCode;

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationLabel?;
    if (otherAs == null) return false;
    return Text == otherAs.Text;
  }

  @override
  String toString() {
    return Text!;
  }
}
