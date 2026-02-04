import 'package:movies/data/tmdb/tmdb_http.dart';

class MoviesOnAirServices {
  static Future<Map<String, dynamic>> getMoviesOnAir({
    required String language,
    int page = 1,
  }) {
    return TmdbHttp.get(
      '/tv/on_the_air',
      query: {
        'language': language,
        'page': '$page',
      },
    );
  }
}
