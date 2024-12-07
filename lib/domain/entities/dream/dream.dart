import 'package:isar/isar.dart';

part 'dream.g.dart';

@collection
class Dream {
  Id id; // isar Id
  final String? title;
  final String description;
  final DateTime? date;
  final List<String>? tags; //TODO: tag class from db tags ¿?
  final List<String>? names;
  final int? rating; //TODO: validate in constructor ¿?
  final int? lucidness;
  final int? quality;
  final int? type;
  final int? mood;
  final bool isFav;

  Dream({
    this.id = Isar.autoIncrement,
    this.title = "",
    this.description = "",
    this.date,
    this.tags,
    this.names,
    this.quality,
    this.type,
    this.mood,
    this.isFav = false,
    this.rating = 0,
    this.lucidness = 0,
  });

  Dream copyWith({
    final Id? id,
    final String? title,
    final String? description,
    final DateTime? date,
    final List<String>? tags,
    final List<String>? names,
    final int? rating,
    final int? lucidness,
    final int? quality,
    final int? type,
    final int? mood,
    final bool? isFav,
  }) {
    return Dream(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      names: names ?? this.names,
      rating: rating ?? this.rating,
      lucidness: lucidness ?? this.lucidness,
      quality: quality ?? this.quality,
      type: type ?? this.type,
      mood: mood ?? this.mood,
      isFav: isFav ?? this.isFav,
    );
  }

  // get year only if its not current, return d/m/y H:m
  String get formattedDate {
    final now = DateTime.now();
    final year = date?.year;
    final month = date?.month;
    final day = date?.day;
    final hour = date?.hour;
    final minute = date?.minute;
    if (year == now.year) {
      return "$day/$month $hour:$minute";
    } else {
      return "$day/$month/$year $hour:$minute";
    }
  }

  @override
  String toString() {
    return 'Dream{id: $id, title: $title, description: $description, date: $date, tags: $tags, names: $names, rating: $rating, lucidness: $lucidness, quality: $quality, type: $type, mood: $mood, isFav: $isFav}';
  }
}
