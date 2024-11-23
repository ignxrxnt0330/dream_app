enum SleepQuality { bad, good, excellent }

enum DreamType { lucid, nightmare, normal }

enum DreamMood { happy, sad, angry, scared, surprised, disgusted, neutral }

class Dream {
  final String id;
  final String? title;
  final String description;
  final String date;
  final List<String>? tags = []; //TODO: tag class from db tags ¿?
  final List<String>? names = [];
  final int? rating = 0; //TODO: validate in constructor ¿?
  final SleepQuality? quality = null;
  final DreamType? type = null;
  final DreamMood? mood = null;
  final bool isFav = false;

  Dream({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

//FIXME: ¿?
  factory Dream.fromJson(Map<String, dynamic> json) {
    return Dream(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
    );
  }
}
