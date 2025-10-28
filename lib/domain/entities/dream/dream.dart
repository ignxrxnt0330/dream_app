import 'dart:convert';

import 'package:dream_app/infrastructure/datasources/sp_config.dart';
import 'package:dream_app/util/custom_date_utils.dart';
import 'package:dream_app/util/custom_string_utils.dart';
import 'package:isar/isar.dart';

part 'dream.g.dart';

@collection
class Dream {
  Id id; // isar Id
  String title;
  String description;
  DateTime? date;
  List<String> names;
  double rating = 3; // 0-5
  int lucidness = 0; // 0-3
  int type = 0; // 0-2
  int mood = 3; // 0-5
  bool isFav;
  bool hidden;
  int descLength;
  int nameCount;

  Dream({
    this.id = Isar.autoIncrement,
    this.title = "",
    this.description = "",
    this.date,
    this.names = const [],
    this.type = 0,
    this.mood = 3,
    this.isFav = false,
    this.rating = 0,
    this.lucidness = 0,
    this.hidden = false,
    this.descLength = 0,
    this.nameCount = 0,
  });

  Dream copyWith({
    final Id? id,
    final String? title,
    final String? description,
    final DateTime? date,
    final List<String>? names,
    final double? rating,
    final int? lucidness,
    final int? type,
    final int? mood,
    final bool? isFav,
    final bool? hidden,
    final int? descLength,
    final int? nameCount,
  }) {
    return Dream(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      names: names ?? this.names,
      rating: rating ?? this.rating,
      lucidness: lucidness ?? this.lucidness,
      type: type ?? this.type,
      mood: mood ?? this.mood,
      isFav: isFav ?? this.isFav,
      hidden: hidden ?? this.hidden,
      descLength: descLength ?? this.descLength,
      nameCount: nameCount ?? this.nameCount,
    );
  }

  // get year only if its not current, return d/m/y H:m
  String get formattedDate {
    return date!.formatDate;
  }

  void initNames() {
    final regexp = RegExp(r'@([\wáéíóúÁÉÍÓÚñÑüÜ]+)', multiLine: true);

    names = regexp
        .allMatches(description)
        .map((match) => match.group(1)?.normalize.toLowerCase())
        .whereType<String>()
        .toList();
  }

  void initHidden() async {
    hidden = title.startsWith(".");
    title = title == "."
        ? ".${await SpConfig().getDefaultTitle() ?? title}"
        : title;
  }

  void initDescLength() {
    descLength = description.length;
  }

  void initNameCount() {
    nameCount = names.length;
  }

  void initMiscFields() {
    initNames();
    initHidden();
    initDescLength();
    initNameCount();
  }

  @override
  String toString() {
    return 'Dream{id: $id, title: $title, description: $description, date: $date, names: $names, rating: $rating, lucidness: $lucidness, type: $type, mood: $mood, isFav: $isFav}';
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'title': title,
      'description': description,
      'date': date!.microsecondsSinceEpoch,
      'rating': rating,
      'lucidness': lucidness,
      'type': type,
      'mood': mood,
      'isFav': isFav,
    });
  }

  factory Dream.fromJson(Map<String, dynamic> json) {
    Dream dream = Dream(
      id: json['id'] ?? Isar.autoIncrement,
      title: json['title'],
      description: json['description'],
      date: DateTime.fromMicrosecondsSinceEpoch(json['date']),
      rating: json['rating'],
      lucidness: json['lucidness'],
      type: json['type'],
      mood: json['mood'],
      isFav: json['isFav'],
    );

    dream.initMiscFields();
    return dream;
  }
}
