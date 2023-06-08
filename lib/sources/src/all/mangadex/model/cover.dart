class CoverAA {
  String? result;
  String? response;
  List<CoverData>? data;
  int? limit;
  int? offset;
  int? total;

  CoverAA(
      {this.result,
      this.response,
      this.data,
      this.limit,
      this.offset,
      this.total});

  CoverAA.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    response = json['response'];
    if (json['data'] != null) {
      data = <CoverData>[];
      json['data'].forEach((v) {
        data!.add(CoverData.fromJson(v));
      });
    }
    limit = json['limit'];
    offset = json['offset'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['response'] = response;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['limit'] = limit;
    data['offset'] = offset;
    data['total'] = total;
    return data;
  }
}

class CoverData {
  String? id;
  String? type;
  Attributes? attributes;
  List<Relationships>? relationships;

  CoverData({this.id, this.type, this.attributes, this.relationships});

  CoverData.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    if (relationships != null) {
      data['relationships'] =
          relationships!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attributes {
  String? description;
  String? volume;
  String? fileName;
  String? locale;
  String? createdAt;
  String? updatedAt;
  int? version;

  Attributes(
      {this.description,
      this.volume,
      this.fileName,
      this.locale,
      this.createdAt,
      this.updatedAt,
      this.version});

  Attributes.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    volume = json['volume'];
    fileName = json['fileName'];
    locale = json['locale'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['volume'] = volume;
    data['fileName'] = fileName;
    data['locale'] = locale;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['version'] = version;
    return data;
  }
}

class Relationships {
  String? id;
  String? type;

  Relationships({this.id, this.type});

  Relationships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}
