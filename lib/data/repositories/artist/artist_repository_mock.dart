import '../../../model/artist/artist.dart';
import 'artist_repository.dart';

class ArtistRepositoryMock implements ArtistRepository {
  final List<Artist> _artists = [];
  List<Artist>? _cachedArtists;

  @override
  Future<List<Artist>> fetchArtists({bool forchFetch = false}) async {

    if (forchFetch) {
      _cachedArtists = null;
    }

    if (_cachedArtists != null) {
      return _cachedArtists!;
    }

    return Future.delayed(Duration(seconds: 4), () {
      _cachedArtists = List.of(_artists);
      throw _cachedArtists!;
    });
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _artists.firstWhere(
        (artist) => artist.id == id,
        orElse: () => throw Exception("No artist with id $id in the database"),
      );
    });
  }
}
