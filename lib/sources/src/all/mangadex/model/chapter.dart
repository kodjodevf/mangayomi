class ChapterMDX {
  String? result;
  String? response;
  List<Data>? data;
  int? limit;
  int? offset;
  int? total;

  ChapterMDX(
      {this.result,
      this.response,
      this.data,
      this.limit,
      this.offset,
      this.total});

  ChapterMDX.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    response = json['response'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    limit = json['limit'];
    offset = json['offset'];
    total = json['total'];
  }
}

class Data {
  String? id;
  String? type;
  Attributes? attributes;
  List<Relationships>? relationships;

  Data({this.id, this.type, this.attributes, this.relationships});

  Data.fromJson(Map<String, dynamic> json) {
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
  String? volume;
  String? chapter;
  String? title;
  String? translatedLanguage;

  String? publishAt;
  String? readableAt;
  String? createdAt;
  String? updatedAt;
  int? pages;
  int? version;

  Attributes(
      {this.volume,
      this.chapter,
      this.title,
      this.translatedLanguage,
      this.publishAt,
      this.readableAt,
      this.createdAt,
      this.updatedAt,
      this.pages,
      this.version});

  Attributes.fromJson(Map<String, dynamic> json) {
    volume = json['volume'];
    chapter = json['chapter'];
    title = json['title'];
    translatedLanguage = json['translatedLanguage'];

    publishAt = json['publishAt'];
    readableAt = json['readableAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    pages = json['pages'];
    version = json['version'];
  }
}

class Relationships {
  String? id;
  String? type;
  RAttributes? attributes;
  Relationships({this.id, this.type, this.attributes});

  Relationships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    // log(json['attributes'].toString());
    attributes = json['attributes'] != null
        ? RAttributes.fromJson(json['attributes'])
        : null;
  }
}

class RAttributes {
  String? name;
  String? username;
  RAttributes({
    this.name,
    this.username,
  });

  RAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
  }
}
