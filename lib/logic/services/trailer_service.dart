import 'package:movies/data/tmdb/tmdb_http.dart';
import 'package:movies/logic/model/tmdb_video.dart';

enum MediaType { movie, tv }

class TrailerService {
  Future<List<TmdbVideo>> fetchTrailerCandidates({
    required MediaType type,
    required int id,
    required String language,
    int max = 8,
  }) async {
    final path = type == MediaType.movie ? '/movie/$id/videos' : '/tv/$id/videos';

    Future<List<TmdbVideo>> load(String lang) async {
      final data = await TmdbHttp.get(path, query: {'language': lang});

      final list = (data['results'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(TmdbVideo.fromJson)
          .where((v) => v.key.isNotEmpty && v.site.toLowerCase() == 'youtube')
          .toList();

      int score(TmdbVideo v) {
        var s = 0;

        final typeLower = v.type.toLowerCase();
        final nameLower = v.name.toLowerCase();

        if (typeLower == 'trailer') s += 1000;
        if (typeLower == 'teaser') s += 250;
        if (typeLower == 'clip') s += 80;

        if (v.official) s += 300;

        if (nameLower.contains('official')) s += 80;
        if (nameLower.contains('trailer')) s += 60;
        if (nameLower.contains('teaser')) s += 20;

        return s;
      }

      list.sort((a, b) => score(b).compareTo(score(a)));

      final uniq = <String>{};
      final out = <TmdbVideo>[];
      for (final v in list) {
        if (uniq.add(v.key)) out.add(v);
        if (out.length == max) break;
      }

      return out;
    }

    var results = await load(language);
    if (results.isEmpty && language != 'en-US') {
      results = await load('en-US');
    }

    return results;
  }
}
