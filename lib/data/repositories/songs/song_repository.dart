import '../../../model/songs/song.dart';

abstract class SongRepository {
  Future<List<Song>> fetchSongs({bool forchFetch = false});
  
  Future<Song?> fetchSongById(String id);

  Future<Song> songLikes(Song song);
}
