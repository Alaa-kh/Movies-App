import 'package:movies/data/tmdb/tmdb_http.dart';

class MoviesQueryServices {
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
