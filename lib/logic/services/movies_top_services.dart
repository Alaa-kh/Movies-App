import 'package:http/http.dart' as http;

import '../../utils/strings.dart';
import '../model/movies_top_model.dart';

class MoviesTopRatedServices {
  static Future<GetTopRatedModel> getMoviesTopRated() async {
    var response = await http.get(Uri.parse(
        '$baseUrl/movie/top_rated?api_key=10d39203e458fc0a8dec50a358c99540&language=en-US&sort_by=with_genres&with_genres=Action&year=2005&page=2'));

    if (response.statusCode == 200) {
      var jsonData = response.body;
      return getTopRatedModelFromJson(jsonData);
    } else {
      return throw Exception('Failed to load product');
    }
  }
}
