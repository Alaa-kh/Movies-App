import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/logic/controller/locale_controller.dart';
import 'package:movies/logic/services/trailer_service.dart';
import 'package:movies/view/widgets/youtube_webview_page.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TrailerSection extends StatefulWidget {
  const TrailerSection({
    super.key,
    required this.type,
    required this.id,
    this.posterUrl,
    this.maxTries = 6,
  });

  final MediaType type;
  final int id;
  final String? posterUrl;
  final int maxTries;

  @override
  State<TrailerSection> createState() => _TrailerSectionState();
}

class _TrailerSectionState extends State<TrailerSection> {
  final _service = TrailerService();

  YoutubePlayerController? _controller;
  StreamSubscription<YoutubePlayerValue>? _sub;

  bool _loading = true;
  bool _failed = false;

  List<String> _candidates = const [];
  int _index = 0;

  int _token = 0;
  Timer? _guard;

  YoutubePlayerParams get _params => const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        playsInline: true,
        strictRelatedVideos: true,
        enableCaption: false,
        origin: 'https://www.youtube-nocookie.com',
      );

  String? get _videoId =>
      (_index >= 0 && _index < _candidates.length) ? _candidates[_index] : null;

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  @override
  void didUpdateWidget(covariant TrailerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id || oldWidget.type != widget.type) {
      _token++;
      _reset();
      _loadCandidates();
    }
  }

  void _reset() {
    _loading = true;
    _failed = false;
    _candidates = const [];
    _index = 0;
    _disposeController();
  }

  Future<void> _disposeController() async {
    _guard?.cancel();
    _guard = null;

    await _sub?.cancel();
    _sub = null;

    final c = _controller;
    _controller = null;

    if (c != null) {
      await c.close();
    }
  }

  Future<void> _loadCandidates() async {
    final t = ++_token;

    setState(() {
      _loading = true;
      _failed = false;
    });

    final locale = Get.find<LocaleController>();
    final videos = await _service.fetchTrailerCandidates(
      type: widget.type,
      id: widget.id,
      language: locale.tmdbLanguage,
      max: 10,
    );

    if (!mounted || t != _token) return;

    final keys = videos.map((e) => e.key).where((e) => e.isNotEmpty).toList();

    if (keys.isEmpty) {
      setState(() {
        _candidates = const [];
        _loading = false;
        _failed = true;
      });
      return;
    }

    setState(() {
      _candidates = keys;
      _index = 0;
    });

    await _attachCurrent(token: t);
  }

  Future<void> _attachCurrent({required int token}) async {
    await _disposeController();
    if (!mounted || token != _token) return;

    final id = _videoId;
    if (id == null) {
      setState(() {
        _loading = false;
        _failed = true;
      });
      return;
    }

    setState(() {
      _loading = true;
      _failed = false;
    });

    final ctrl = YoutubePlayerController.fromVideoId(
      videoId: id,
      autoPlay: false,
      params: _params,
    );

    _controller = ctrl;

    _guard?.cancel();
    _guard = Timer(const Duration(seconds: 3), () {
      if (!mounted || token != _token) return;
      setState(() => _loading = false);
    });

    _sub = ctrl.stream.listen((v) async {
      if (!mounted || token != _token) return;

      if (_loading) setState(() => _loading = false);

      if (v.hasError) {
        final next = _index + 1;
        if (next < _candidates.length && next < widget.maxTries) {
          setState(() => _index = next);
          await _attachCurrent(token: token);
          return;
        }

        setState(() {
          _failed = true;
          _loading = false;
        });
      }
    });
  }

  void _openYoutubeInApp(String videoId) {
    Get.to(() => YoutubeWebViewPage(videoId: videoId, title: 'Trailer'));
  }

  Future<void> _retry() async {
    final t = ++_token;
    if (_candidates.isEmpty) {
      await _loadCandidates();
      return;
    }

    final next = _index + 1;
    if (next < _candidates.length && next < widget.maxTries) {
      setState(() => _index = next);
      await _attachCurrent(token: t);
      return;
    }

    setState(() => _index = 0);
    await _attachCurrent(token: t);
  }

  Widget _fallback(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final first =
        _videoId ?? (_candidates.isNotEmpty ? _candidates.first : null);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: scheme.surfaceContainerHighest.withOpacity(.35),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (widget.posterUrl != null)
            Positioned.fill(
              child: Image.network(widget.posterUrl!, fit: BoxFit.cover),
            ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(.15),
                    Colors.black.withOpacity(.75),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_circle_fill,
                      size: 56, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    'Trailer unavailable here',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.92),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilledButton.icon(
                        onPressed: first == null
                            ? null
                            : () => _openYoutubeInApp(first),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Open on YouTube'),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: _retry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try another'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _token++;
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ctrl = _controller;
    final id = _videoId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trailer',
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (!_failed && ctrl != null)
                  YoutubePlayer(controller: ctrl, aspectRatio: 16 / 9)
                else
                  _fallback(context),
                if (_loading)
                  Container(
                    color: Colors.black.withOpacity(.35),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                if (id != null)
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: FilledButton(
                      onPressed: () => _openYoutubeInApp(id),
                      child: const Text('Open on YouTube'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
