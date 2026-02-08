import 'package:movies/data/tmdb/tmdb_http.dart';

class FetchData {
  /// Fetches movies from TMDB discover endpoint using language and pagination.
  static Future<Map<String, dynamic>> getMovies({
    required String language,
    int page = 1,
  }) {
    return TmdbHttp.get(
      '/discover/movie',
      query: {
        'language': language,
        'page': '$page',
        'sort_by': 'popularity.desc',
      },
    );
  }
}
