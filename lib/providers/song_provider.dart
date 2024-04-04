import 'package:boanmusic/domain/usecases/fetch_songs_by_artist_id.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boanmusic/data/datasource/song_api.dart';
import 'package:boanmusic/data/repository/song_repository.dart';
import 'package:boanmusic/domain/usecases/fetch_songs.dart';
import 'package:boanmusic/domain/usecases/fetch_songs_by_album_id.dart';
import 'fetch_song_by_id_notifier.dart';

class SongProvider extends StatelessWidget {
  final Widget child;

  const SongProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SongApi>(
          create: (_) => SongApi(baseUrl: 'https://localhost:44300'),
        ),
        ProxyProvider<SongApi, SongRepository>(
          update: (_, api, __) => SongRepository(songApi: api),
        ),
        ProxyProvider<SongRepository, FetchSongs>(
          update: (_, repo, __) => FetchSongs(repository: repo),
        ),
        ProxyProvider<SongRepository, FetchSongsByAlbumId>(
          update: (_, repo, __) => FetchSongsByAlbumId(repository: repo),
        ),
        ProxyProvider<SongRepository, FetchSongsByArtistId>(
          update: (_, repo, __) => FetchSongsByArtistId(repository: repo),
        ),
        ChangeNotifierProvider<FetchSongById>(
          create: (_) =>
              FetchSongById(repository: context.read<SongRepository>()),
        ),
      ],
      child: child,
    );
  }
}
