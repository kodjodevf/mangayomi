class MDXDetail {
  String? result;
  String? response;
  Dataa? data;

  MDXDetail({this.result, this.response, this.data});

  MDXDetail.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    response = json['response'];
    data = json['data'] != null ? Dataa.fromJson(json['data']) : null;
  }
}

class Dataa {
  String? id;
  String? type;
  Attributes? attributes;
  List<Relationships>? relationships;

  Dataa({this.id, this.type, this.attributes, this.relationships});

  Dataa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? Attributes.fromJson(json['attributes'])
        : null;
    if (json['relationships'] != null) {
      relationships = <Relationships>[];
      json['relationships'].forEach((v) {
        relationships!.add(Relationships.fromJson(v));
      });
    }
  }
}

class Attributes {
  Title? title;

  Map<String, dynamic>? description;
  bool? isLocked;
  String? originalLanguage;
  String? lastVolume;
  String? lastChapter;
  String? publicationDemographic;
  String? status;
  int? year;
  String? contentRating;
  List<Tags>? tags;
  String? state;
  bool? chapterNumbersResetOnNewVolume;
  String? createdAt;
  String? updatedAt;
  int? version;
  List<String>? availableTranslatedLanguages;
  String? latestUploadedChapter;

  Attributes(
      {this.title,
      this.description,
      this.isLocked,
      this.originalLanguage,
      this.lastVolume,
      this.lastChapter,
      this.publicationDemographic,
      this.status,
      this.year,
      this.contentRating,
      this.tags,
      this.state,
      this.chapterNumbersResetOnNewVolume,
      this.createdAt,
      this.updatedAt,
      this.version,
      this.availableTranslatedLanguages,
      this.latestUploadedChapter});

  Attributes.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null ? Title.fromJson(json['title']) : null;
    description = json['description'];
    isLocked = json['isLocked'];

    originalLanguage = json['originalLanguage'];
    lastVolume = json['lastVolume'];
    lastChapter = json['lastChapter'];
    publicationDemographic = json['publicationDemographic'];
    status = json['status'];
    year = json['year'];
    contentRating = json['contentRating'];
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
    state = json['state'];
    chapterNumbersResetOnNewVolume = json['chapterNumbersResetOnNewVolume'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['version'];
    availableTranslatedLanguages =
        json['availableTranslatedLanguages'].cast<String>();
    latestUploadedChapter = json['latestUploadedChapter'];
  }
}

class Title {
  String? en;

  Title({this.en});

  Title.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  
}

class Tags {
  String? id;
  String? type;
  TAttributes? attributes;

  Tags({this.id, this.type, this.attributes});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? TAttributes.fromJson(json['attributes'])
        : null;
  }
}

class TAttributes {
  Title? name;
  Map<String, dynamic>? description;
  String? group;
  int? version;

  TAttributes({this.name, this.description, this.group, this.version});

  TAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? Title.fromJson(json['name']) : null;
    description = json['description'];
    group = json['group'];
    version = json['version'];
  }
}

class Relationships {
  String? id;
  String? type;
  RAttributes? attributes;
  String? related;

  Relationships({this.id, this.type, this.attributes, this.related});

  Relationships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? RAttributes.fromJson(json['attributes'])
        : null;
    related = json['related'];
  }
}

class RAttributes {
  String? name;
  Title? biography;
  String? twitter;

  String? createdAt;
  String? updatedAt;
  int? version;
  String? description;
  String? volume;
  String? fileName;
  String? locale;

  RAttributes(
      {this.name,
      this.biography,
      this.twitter,
      this.createdAt,
      this.updatedAt,
      this.version,
      this.description,
      this.volume,
      this.fileName,
      this.locale});

  RAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];

    biography =
        json['biography'] != null ? Title.fromJson(json['biography']) : null;
    twitter = json['twitter'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['version'];
    description = json['description'];
    volume = json['volume'];
    fileName = json['fileName'];
    locale = json['locale'];
  }
}
