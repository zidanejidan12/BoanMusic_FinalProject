enum GenreType { Rock, Pop, HipHop, Jazz, Electronic, Techno }

class SongModel {
  int id;
  String title;
  GenreType genre;
  DateTime releaseDate;
  int runtimeInSeconds;
  bool isExplicit;
  bool isHidden;
  int albumId;
  String imageSongURL;
  String songMP3;

  SongModel({
    required this.id,
    required this.title,
    required this.genre,
    required this.releaseDate,
    required this.runtimeInSeconds,
    required this.isExplicit,
    this.isHidden = false,
    required this.albumId,
    required this.imageSongURL,
    required this.songMP3,
  });
}
