import 'package:isar/isar.dart';

part 'dream.g.dart';

enum SleepQuality { bad, good, excellent }

enum DreamType { dream, nightmare }

enum DreamMood { happy, sad, angry, scared, surprised, disgusted, neutral }

@collection
class Dream {
  Id id = Isar.autoIncrement; // isar Id
  final String? title;
  final String description;
  final DateTime? date;
  final List<String>? tags; //TODO: tag class from db tags ¿?
  final List<String>? names;
  final int? rating; //TODO: validate in constructor ¿?
  final int? lucidness;
  @Enumerated(EnumType.name)
  final SleepQuality? quality;
  @Enumerated(EnumType.name)
  final DreamType? type;
  @Enumerated(EnumType.name)
  final DreamMood? mood;
  final bool isFav;

  Dream({
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
    final String? title,
    final String? description,
    final DateTime? date,
    final List<String>? tags,
    final List<String>? names,
    final int? rating,
    final int? lucidness,
    final SleepQuality? quality,
    final DreamType? type,
    final DreamMood? mood,
    final bool? isFav,
  }) {
    return Dream(
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
}