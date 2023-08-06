import 'package:http/http.dart' as http;
import 'package:movies/utils/strings.dart';

// import '../../utils/strings.dart';
import '../model/movies_on_air_model.dart';

class MoviesOnAirServices {
  static Future<GetMoviesOnAirModel> getMoviesOnAir() async {
    var response = await http.get(Uri.parse(
        '$baseUrl/tv/on_the_air?api_key=61222fdc8669a6536695abd204a053a8&language=en&page=1&sort_by=popularity.desc'));

    if (response.statusCode == 200) {
      var jsonData = response.body;
      return getMoviesOnAirModelFromJson(jsonData);
    } else {
      return throw Exception('Failed to load product');
    }
  }
}
