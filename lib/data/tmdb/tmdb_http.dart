import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Strongly-typed TMDB HTTP error with status code and raw response body.
class TmdbHttpException implements Exception {
  final int statusCode;
  final String body;

  const TmdbHttpException(this.statusCode, this.body);

  /// Formats the error as a readable string for logs/snackbars.
  @override
  String toString() => 'TMDB error $statusCode: $body';
}

class TmdbHttp {
  static const _host = 'api.themoviedb.org';
  static const _basePath = '/3';

  /// Builds request headers and validates the access token exists.
  static Map<String, String> _headers() {
    final token = dotenv.env['TMDB_READ_ACCESS_TOKEN'];
    if (token == null || token.isEmpty) {
      throw StateError('TMDB_READ_ACCESS_TOKEN is missing');
    }
    return {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Performs a GET request to TMDB and returns the decoded JSON map.
  static Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
  }) async {
    final uri = Uri.https(_host, '$_basePath$path', query);
    final res = await http.get(uri, headers: _headers());

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw TmdbHttpException(res.statusCode, res.body);
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
