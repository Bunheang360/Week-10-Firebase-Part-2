import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https(
    'w9-database-4ff73-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/songs.json',
  );

  Uri _songUri(String id) => Uri.https(
    'w9-database-4ff73-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/songs/$id.json',
  );

  List<Song>? _songsCached;

  @override
  Future<List<Song>> fetchSongs({bool forchFetch = false}) async {
    if (forchFetch) {
      _songsCached = null;
    }

    if (_songsCached != null) {
      return _songsCached!;
    }

    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      _songsCached = result;
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

  @override
  Future<Song> songLikes(Song song) async {
    final int updateSongLikes = song.likes + 1;

    final http.Response response = await http.patch(
      _songUri(song.id),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({SongDto.likesKey: updateSongLikes}),
    );

    if (response.statusCode == 200) {
      final Song updateToSong = song.copyWith(likes: updateSongLikes);

      if (_songsCached != null) {
        _songsCached = _songsCached!.map((Song _songsCached) {
          if (_songsCached.id != updateToSong.id) {
            return _songsCached;
          }
          return updateToSong;
        }).toList();
      }

      return updateToSong;
    } else {
      throw Exception('Failed to like song');
    }
  }
}
