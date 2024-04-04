import 'package:boanmusic/domain/entities/song_model.dart';

class Album {
  int id;
  String title;
  GenreType genre;
  String description;
  DateTime releaseDate;
  bool isExplicit;
  String imageCoverURL;
  int artistId;

  Album({
    required this.id,
    required this.title,
    required this.genre,
    required this.description,
    required this.releaseDate,
    required this.isExplicit,
    required this.imageCoverURL,
    required this.artistId,
  });

  // Define a factory constructor named fromJson to parse JSON data into an Album object
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
      genre: GenreType.values[json['genre']],
      description: json['description'] ?? '',
      releaseDate: DateTime.parse(json['releaseDate']),
      isExplicit: json['isExplicit'],
      imageCoverURL: json['imageCoverURL'],
      artistId: json['artistId'],
    );
  }
}
