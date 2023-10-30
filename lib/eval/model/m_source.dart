class MSource {
  int? id;

  String? name;

  String? baseUrl;

  String? lang;

  bool? isFullData;

  bool? hasCloudflare;

  String? dateFormat;

  String? dateFormatLocale;

  String? apiUrl;

  MSource(
      {this.id,
      this.name,
      this.baseUrl,
      this.lang,
      this.isFullData,
      this.hasCloudflare,
      this.dateFormat,
      this.dateFormatLocale,
      this.apiUrl});
}
