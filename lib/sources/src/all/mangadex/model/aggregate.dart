
class Aggregate {
  String? result;
  Map<String, AggregateVolumes>? volumes;

  Aggregate({this.result, this.volumes});

  Aggregate.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['volumes'] is List<dynamic>) {
      volumes = (json['volumes'] as List<dynamic>).asMap().map((key, value) =>
          MapEntry(key.toString(),
              AggregateVolumes.fromJson(value as Map<String, dynamic>)));
    } else {
      volumes = (json['volumes'] as Map<String, dynamic>?)?.map((key, value) =>
          MapEntry(
              key, AggregateVolumes.fromJson(value as Map<String, dynamic>)));
    }
  }
}

class AggregateVolumes {
  String? volume;
  String? count;
  Map<String, AggregateChapter>? chapters;

  AggregateVolumes({this.volume, this.chapters, this.count});
  AggregateVolumes.fromJson(Map<String, dynamic> json) {
    volume = json['volume'];
    count = json['count'].toString();
    if (json['chapters'] is List<dynamic>) {
      chapters = (json['chapters'] as List<dynamic>).asMap().map((key, value) =>
          MapEntry(key.toString(),
              AggregateChapter.fromJson(value as Map<String, dynamic>)));
    } else {
      chapters = (json['chapters'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(
              key, AggregateChapter.fromJson(value as Map<String, dynamic>)));
    }
  }
}

class AggregateChapter {
  String? chapter;
  String? count;

  AggregateChapter({this.chapter, this.count});
  AggregateChapter.fromJson(Map<String, dynamic> json) {
    chapter = json['chapter'];
    count = json['count'].toString();
  }
}
