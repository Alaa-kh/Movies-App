import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class YoutubeWebViewPage extends StatefulWidget {
  const YoutubeWebViewPage({
    super.key,
    required this.videoId,
    this.title = 'Trailer',
    this.autoPlay = true,
  });

  final String videoId;
  final String title;
  final bool autoPlay;

  @override
  State<YoutubeWebViewPage> createState() => _YoutubeWebViewPageState();
}

class _YoutubeWebViewPageState extends State<YoutubeWebViewPage> {
  late final WebViewController _controller;
  int _progress = 0;

  Uri get _url {
    final autoplay = widget.autoPlay ? 1 : 0;
    return Uri.parse(
        'https://m.youtube.com/watch?v=${widget.videoId}&autoplay=$autoplay');
  }

  @override
  void initState() {
    super.initState();

    final params = const PlatformWebViewControllerCreationParams();
    final controller = WebViewController.fromPlatformCreationParams(params);

    final platform = controller.platform;
    if (platform is AndroidWebViewController) {
      platform.setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) => setState(() => _progress = p),
        ),
      )
      ..loadRequest(_url);
  }

  Future<bool> _handleBack() async {
    final canGoBack = await _controller.canGoBack();
    if (canGoBack) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final loading = _progress < 100;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _handleBack();
        if (shouldPop && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () => _controller.reload(),
              icon: const Icon(Icons.refresh),
            ),
          ],
          bottom: loading
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(2),
                  child: LinearProgressIndicator(value: _progress / 100),
                )
              : null,
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
