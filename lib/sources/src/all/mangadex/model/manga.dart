class MangaDexDto {
  String? result;
  String? response;
  List<Data>? data;
  int? limit;
  int? offset;
  int? total;

  MangaDexDto(
      {this.result,
      this.response,
      this.data,
      this.limit,
      this.offset,
      this.total});

  MangaDexDto.fromJson(Map<String, dynamic> json) {
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
  Map<String, dynamic>? title;
  List<dynamic>? altTitles;
  Description? description;
  bool? isLocked;
  Links? links;
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
      this.altTitles,
      this.description,
      this.isLocked,
      this.links,
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
    title = json['title'] as Map<String, dynamic>;
    if (json['altTitles'] != null) {
      altTitles = json['altTitles'];
    }
    description = json['description'] != null
        ? Description.fromJson(json['description'])
        : null;
    isLocked = json['isLocked'];
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
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



class Description {
  String? en;
  String? fr;
  String? pt;
  String? ptBr;
  String? zhHk;
  String? ru;
  String? es;
  String? ja;
  String? tr;
  String? uk;
  String? esLa;
  String? ko;
  String? de;
  String? id;
  String? it;
  String? pl;
  String? th;
  String? zh;
  String? cs;

  Description(
      {this.en,
      this.fr,
      this.pt,
      this.ptBr,
      this.zhHk,
      this.ru,
      this.es,
      this.ja,
      this.tr,
      this.uk,
      this.esLa,
      this.ko,
      this.de,
      this.id,
      this.it,
      this.pl,
      this.th,
      this.zh,
      this.cs});

  Description.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    fr = json['fr'];
    pt = json['pt'];
    ptBr = json['pt-br'];
    zhHk = json['zh-hk'];
    ru = json['ru'];
    es = json['es'];
    ja = json['ja'];
    tr = json['tr'];
    uk = json['uk'];
    esLa = json['es-la'];
    ko = json['ko'];
    de = json['de'];
    id = json['id'];
    it = json['it'];
    pl = json['pl'];
    th = json['th'];
    zh = json['zh'];
    cs = json['cs'];
  }
}

class Links {
  String? al;
  String? mu;
  String? amz;
  String? mal;
  String? engtl;
  String? kt;
  String? cdj;
  String? ebj;
  String? raw;
  String? ap;
  String? bw;
  String? nu;

  Links(
      {this.al,
      this.mu,
      this.amz,
      this.mal,
      this.engtl,
      this.kt,
      this.cdj,
      this.ebj,
      this.raw,
      this.ap,
      this.bw,
      this.nu});

  Links.fromJson(Map<String, dynamic> json) {
    al = json['al'];
    mu = json['mu'];
    amz = json['amz'];
    mal = json['mal'];
    engtl = json['engtl'];
    kt = json['kt'];
    cdj = json['cdj'];
    ebj = json['ebj'];
    raw = json['raw'];
    ap = json['ap'];
    bw = json['bw'];
    nu = json['nu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['al'] = al;
    data['mu'] = mu;
    data['amz'] = amz;
    data['mal'] = mal;
    data['engtl'] = engtl;
    data['kt'] = kt;
    data['cdj'] = cdj;
    data['ebj'] = ebj;
    data['raw'] = raw;
    data['ap'] = ap;
    data['bw'] = bw;
    data['nu'] = nu;
    return data;
  }
}

class Tags {
  TagAttributes? attributes;

  Tags({
    this.attributes,
  });

  Tags.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? TagAttributes.fromJson(json['attributes'])
        : null;
  }
}

class TagAttributes {
  String? group;

  TagAttributes({this.group});

  TagAttributes.fromJson(Map<String, dynamic> json) {
    group = json['group'];
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
  String? description;
  String? volume;
  String? fileName;
  String? locale;
  String? createdAt;
  String? updatedAt;
  int? version;

  RAttributes(
      {this.description,
      this.volume,
      this.fileName,
      this.locale,
      this.createdAt,
      this.updatedAt,
      this.version});

  RAttributes.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    volume = json['volume'];
    fileName = json['fileName'];
    locale = json['locale'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['version'];
  }
}
