import 'package:http/http.dart' as http;
import 'package:movies/logic/model/movies_model.dart';

import '../../utils/strings.dart';

class FetchData {
  static Future<GetMoviesModel> getMovies() async {
    var response = await http.get(Uri.parse(
        '$baseUrl/discover/movie?api_key=61222fdc8669a6536695abd204a053a8&language=en&page=1&sort_by=popularity.desc'));

    if (response.statusCode == 200) {
      var jsonData = response.body;
      return getMoviesModelFromJson(jsonData);
    } else {
      return throw Exception('Failed to load product');
    }
  }
}
