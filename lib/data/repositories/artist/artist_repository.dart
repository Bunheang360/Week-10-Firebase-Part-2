import '../../../model/artist/artist.dart';
 

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists({
    bool forchFetch = false
  }
  );
  
  Future<Artist?> fetchArtistById(String id);
}
