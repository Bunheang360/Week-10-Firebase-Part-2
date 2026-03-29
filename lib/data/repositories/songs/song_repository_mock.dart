// song_repository_mock.dart

import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [  ];
  List<Song>? _songsCached;

  @override
  Future<List<Song>> fetchSongs({bool forchFetch = false}) async {

    if (forchFetch) {
      _songsCached = null;
    }

    if (_songsCached != null) {
      return _songsCached!;
    }

    return Future.delayed(Duration(seconds: 4), () {
      _songsCached = List.of(_songs);
      throw _songsCached!;
    });
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _songs.firstWhere(
        (song) => song.id == id,
        orElse: () => throw Exception("No song with id $id in the database"),
      );
    });
  }

  @override
  Future<Song> songLikes (Song song) async {
    return Future.delayed(Duration(seconds: 5),() {
      final int songNumber = _songs.indexWhere((item) => item.id == song.id);

      if (songNumber == -1) {
        throw Exception("No song with ${song.id} is in the database");
      }

      final Song updateSongLikes = _songs[songNumber].copyWith(
        likes: _songs[songNumber].likes + 1,
      );

      _songs[songNumber] = updateSongLikes;
      if (_songsCached != null) {
        _songsCached![songNumber] = updateSongLikes;
      }
      return updateSongLikes;

    });
  }
}
