import 'package:http/http.dart' as http;

import '../../utils/strings.dart';
import '../model/movies_query_model.dart';

class MoviesQueryServices {
  static Future<GetMoviesQueryModel> getMoviesQuery() async {
    var response = await http.get(Uri.parse(
        '$baseUrl/search/movie?api_key=61222fdc8669a6536695abd204a053a8&language=en&query=hell&page=3'));

    if (response.statusCode == 200) {
      var jsonData = response.body;
      return getMoviesQueryModelFromJson(jsonData);
    } else {
      return throw Exception('Failed to load product');
    }
  }
}
