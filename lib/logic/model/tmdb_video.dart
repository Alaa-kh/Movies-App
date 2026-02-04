class TmdbVideo {
  const TmdbVideo({
    required this.name,
    required this.key,
    required this.site,
    required this.type,
    required this.official,
  });

  final String name;
  final String key;
  final String site;
  final String type;
  final bool official;

  factory TmdbVideo.fromJson(Map<String, dynamic> json) {
    return TmdbVideo(
      name: (json['name'] as String?) ?? '',
      key: (json['key'] as String?) ?? '',
      site: (json['site'] as String?) ?? '',
      type: (json['type'] as String?) ?? '',
      official: (json['official'] as bool?) ?? false,
    );
  }
}
