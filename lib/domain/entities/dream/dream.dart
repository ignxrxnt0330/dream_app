import 'dart:convert';

import 'package:isar/isar.dart';

part 'dream.g.dart';

@collection
class Dream {
  Id id; // isar Id
  final String? title;
  final String description;
  final DateTime? date;
  List<String>? names;
  final int? rating; // 0-5
  final int? lucidness; // 0-3
  final int? type; // 0-2
  final int? mood; // 0-5
  final bool isFav;
  bool hidden;

  Dream({
    this.id = Isar.autoIncrement,
    this.title = "",
    this.description = "",
    this.date,
    this.names,
    this.type,
    this.mood,
    this.isFav = false,
    this.rating = 0,
    this.lucidness = 0,
    this.hidden = false,
  });

  Dream copyWith({
    final Id? id,
    final String? title,
    final String? description,
    final DateTime? date,
    final List<String>? names,
    final int? rating,
    final int? lucidness,
    final int? type,
    final int? mood,
    final bool? isFav,
    final bool? hidden,
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
    );
  }

  // get year only if its not current, return d/m/y H:m
  String get formattedDate {
    final now = DateTime.now();
    final year = date?.year;
    final month = date?.month.toString().padLeft(2, '0');
    final day = date?.day.toString().padLeft(2, '0');
    final hour = date?.hour.toString().padLeft(2, '0');
    final minute = date?.minute.toString().padLeft(2, '0');
    if (year == now.year) {
      return "$day/$month $hour:$minute";
    } else {
      return "$day/$month/$year $hour:$minute";
    }
  }

  void initNames() {
    const String excluded = ',.!?"()-';
    final regex = RegExp('[$excluded]');

    names = description.split(RegExp(r'[\s\n]')).where((element) => element.startsWith("@")).toList().map((e) => e.substring(1).toLowerCase().replaceAll(regex, "")).toSet().toList();
  }

  void initHidden() {
    if (title == null && title!.isEmpty) return;
    hidden = title!.startsWith(".");
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
      'names': names,
      'rating': rating,
      'lucidness': lucidness,
      'type': type,
      'mood': mood,
      'isFav': isFav,
      "hidden": hidden,
    });
  }

  factory Dream.fromJson(Map<String, dynamic> json) {
    return Dream(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.fromMicrosecondsSinceEpoch(json['date']),
      names: (json['names'] as List<dynamic>?)?.map((e) => e as String).toList(),
      rating: json['rating'],
      lucidness: json['lucidness'],
      type: json['type'],
      mood: json['mood'],
      isFav: json['isFav'],
      hidden: json['hidden'],
    );
  }
}
