import 'package:movies/data/tmdb/tmdb_http.dart';

class MoviesTopRatedServices {
  /// Fetches top-rated movies from TMDB using language and pagination.
  static Future<Map<String, dynamic>> getMoviesTopRated({
    required String language,
    int page = 1,
  }) {
    return TmdbHttp.get(
      '/movie/top_rated',
      query: {
        'language': language,
        'page': '$page',
      },
    );
  }
}
