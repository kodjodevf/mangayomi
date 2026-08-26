class Cookie {
  Cookie({
    required this.name,
    required this.value,
    this.expiresDate,
    required this.domain,
    required this.path,
    this.isSecure = false,
    this.isHttpOnly = false,
  });

  final String name;
  final String value;
  final DateTime? expiresDate;
  final String domain;
  final String path;
  final bool isSecure;
  final bool isHttpOnly;
}
