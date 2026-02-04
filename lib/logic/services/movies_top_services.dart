import 'package:movies/data/tmdb/tmdb_http.dart';

class MoviesTopRatedServices {
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
