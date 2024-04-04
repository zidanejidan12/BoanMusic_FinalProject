import 'package:boanmusic/domain/usecases/fetch_albums.dart';
import 'package:boanmusic/domain/usecases/fetch_artist.dart';
import 'package:boanmusic/domain/usecases/fetch_songs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boanmusic/providers/login_user_provider.dart';
import 'package:boanmusic/presentation/song_list_screen.dart';

class UserLoginScreen extends StatefulWidget {
  final Function fetchSongs;
  final Function fetchAlbums;
  final Function fetchArtists;

  UserLoginScreen({
    required this.fetchSongs,
    required this.fetchAlbums,
    required this.fetchArtists,
  });

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Call the loginUser method from LoginUserProvider
                Provider.of<LoginUserProvider>(context, listen: false)
                    .loginUser(
                  _usernameController.text.trim(),
                  _passwordController.text.trim(),
                )
                    .then((_) {
                  // Navigate to SongListScreen upon successful login and pass the required parameters
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongListScreen(
                        fetchSongs:
                            Provider.of<FetchSongs>(context, listen: false),
                        fetchAlbums:
                            Provider.of<FetchAlbums>(context, listen: false),
                        fetchArtists:
                            Provider.of<FetchArtists>(context, listen: false),
                      ),
                    ),
                  );
                }).catchError((error) {
                  // Show an error message if login fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to login: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
