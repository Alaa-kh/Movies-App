import 'package:movies/data/tmdb/tmdb_http.dart';

class MoviesQueryServices {
  /// Searches movies on TMDB using the given query, language, and pagination.
  static Future<Map<String, dynamic>> getMoviesQuery({
    required String language,
    required String query,
    int page = 1,
  }) {
    return TmdbHttp.get(
      '/search/movie',
      query: {
        'language': language,
        'query': query,
        'page': '$page',
      },
    );
  }
}
