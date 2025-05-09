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

  String? additionalParams;

  String? notes;

  MSource({
    this.id,
    this.name,
    this.baseUrl,
    this.lang,
    this.isFullData,
    this.hasCloudflare,
    this.dateFormat,
    this.dateFormatLocale,
    this.apiUrl,
    this.additionalParams,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'apiUrl': apiUrl,
    'baseUrl': baseUrl,
    'dateFormat': dateFormat,
    'dateFormatLocale': dateFormatLocale,
    'hasCloudflare': hasCloudflare,
    'id': id,
    'isFullData': isFullData,
    'lang': lang,
    'name': name,
    'additionalParams': additionalParams,
    'notes': notes,
  };
}
