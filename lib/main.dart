import 'package:boanmusic/domain/usecases/fetch_albums_by_artist_id.dart';
import 'package:boanmusic/domain/usecases/login_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boanmusic/providers/login_user_provider.dart';
import 'package:boanmusic/presentation/user_login_screen.dart';
import 'package:boanmusic/data/datasource/user_api.dart';
import 'package:boanmusic/data/repository/user_repository.dart';
import 'package:boanmusic/data/datasource/song_api.dart';
import 'package:boanmusic/data/datasource/album_api.dart';
import 'package:boanmusic/data/datasource/artist_api.dart';
import 'package:boanmusic/data/repository/song_repository.dart';
import 'package:boanmusic/data/repository/album_repository.dart';
import 'package:boanmusic/data/repository/artist_repository.dart';
import 'package:boanmusic/domain/usecases/fetch_songs.dart';
import 'package:boanmusic/domain/usecases/fetch_albums.dart';
import 'package:boanmusic/domain/usecases/fetch_artist.dart';
import 'package:boanmusic/domain/usecases/fetch_song_by_id.dart';
import 'package:boanmusic/domain/usecases/fetch_songs_by_album_id.dart';
import 'package:boanmusic/domain/usecases/fetch_songs_by_artist_id.dart';
import 'package:boanmusic/providers/audio_player_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SongApi>(
          create: (_) => SongApi(baseUrl: 'https://localhost:44300'),
        ),
        Provider<AlbumApi>(
          create: (_) => AlbumApi(baseUrl: 'https://localhost:44300'),
        ),
        Provider<ArtistApi>(
          create: (_) => ArtistApi(baseUrl: 'https://localhost:44300'),
        ),
        ProxyProvider<SongApi, SongRepository>(
          update: (_, api, __) => SongRepository(songApi: api),
        ),
        ProxyProvider<AlbumApi, AlbumRepository>(
          update: (_, api, __) => AlbumRepository(albumApi: api),
        ),
        ProxyProvider<ArtistApi, ArtistRepository>(
          update: (_, api, __) => ArtistRepository(artistApi: api),
        ),
        ProxyProvider<SongRepository, FetchSongs>(
          update: (_, repo, __) => FetchSongs(repository: repo),
        ),
        ProxyProvider<AlbumRepository, FetchAlbums>(
          update: (_, repo, __) => FetchAlbums(repository: repo),
        ),
        ProxyProvider<AlbumRepository, FetchAlbumsByArtistId>(
          update: (_, repo, __) => FetchAlbumsByArtistId(repository: repo),
        ),
        ProxyProvider<ArtistRepository, FetchArtists>(
          update: (_, repo, __) => FetchArtists(repository: repo),
        ),
        ProxyProvider<SongRepository, FetchSongById>(
          update: (_, repo, __) => FetchSongById(repository: repo),
        ),
        ProxyProvider<SongRepository, FetchSongsByAlbumId>(
          update: (_, repo, __) => FetchSongsByAlbumId(repository: repo),
        ),
        ProxyProvider<SongRepository, FetchSongsByArtistId>(
          update: (_, repo, __) => FetchSongsByArtistId(repository: repo),
        ),
        ChangeNotifierProvider<AudioPlayerState>(
          create: (_) => AudioPlayerState(),
        ),
        ChangeNotifierProvider<LoginUserProvider>(
          create: (_) => LoginUserProvider(
            loginUser: LoginUser(
              repository: UserRepository(
                userApi: UserApi(baseUrl: 'https://localhost:44300'),
              ),
            ),
            userRepository: UserRepository(
              userApi: UserApi(baseUrl: 'https://localhost:44300'),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'BoanMusic',
        home: Consumer3<FetchSongs, FetchAlbums, FetchArtists>(
          builder: (_, fetchSongs, fetchAlbums, fetchArtists, __) =>
              UserLoginScreen(
            fetchSongs: fetchSongs,
            fetchAlbums: fetchAlbums,
            fetchArtists: fetchArtists,
          ),
        ),
      ),
    );
  }
}
