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
  final DateTime date;
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
    required this.title,
    required this.description,
    required this.date,
    this.tags,
    this.names,
    this.quality,
    this.type,
    this.mood,
    this.isFav = false,
    this.rating = 0,
    this.lucidness = 0,
  });

  // from json with all fields
  Dream.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        date = json['date'],
        tags = json['tags'],
        names = json['names'],
        rating = json['rating'],
        lucidness = json['lucidness'],
        quality = json['quality'],
        type = json['type'],
        mood = json['mood'],
        isFav = json['isFav'];
}
