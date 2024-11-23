part of 'dream_bloc.dart';

class DreamState extends Equatable {
  final int id;
  final String title;
  final String description;
  final DateTime? date;
  final List<String>? tags;
  final List<String>? names;
  final SleepQuality? quality;
  final DreamType? type;
  final DreamMood? mood;
  final bool isFav;
  final int? rating;
  final int? lucidness;

  const DreamState({
    this.id = 0,
    this.title = "",
    this.description = "",
    this.date,
    this.tags,
    this.names,
    this.quality,
    this.type,
    this.mood,
    this.isFav = false,
    this.rating,
    this.lucidness,
  });

  DreamState copyWith({
    final id,
    final title,
    final description,
    final date,
    final tags,
    final names,
    final quality,
    final type,
    final mood,
    final isFav,
    final rating,
    final lucidness,
  }) {
    return DreamState(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      names: names ?? this.names,
      quality: quality ?? this.quality,
      type: type ?? this.type,
      mood: mood ?? this.mood,
      isFav: isFav ?? this.isFav,
      rating: rating ?? this.rating,
      lucidness: lucidness ?? this.lucidness,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        date,
        tags,
        names,
        quality,
        type,
        mood,
        isFav,
        rating,
        lucidness,
      ];
}
