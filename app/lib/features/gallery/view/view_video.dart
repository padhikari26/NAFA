import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ViewVideoPage extends StatefulWidget {
  final String videoUrl;
  const ViewVideoPage({super.key, required this.videoUrl});

  @override
  State<ViewVideoPage> createState() => _ViewVideoPageState();
}

class _ViewVideoPageState extends State<ViewVideoPage> {
  late final CachedVideoPlayerPlus _player;

  ChewieController? _chewieController;
  DataSourceType? _dataSourceType;

  @override
  void initState() {
    super.initState();

    _player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(
        widget.videoUrl,
      ),
      invalidateCacheIfOlderThan: const Duration(days: 42),
    );
    _player.initialize().then((_) {
      if (!mounted) return;

      setState(() {
        _dataSourceType = _controller.dataSourceType;

        _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,
          allowMuting: true,
          showOptions: false,
          aspectRatio: _controller.value.aspectRatio,
          allowedScreenSleep: false,
          deviceOrientationsAfterFullScreen: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
          ],
          deviceOrientationsOnEnterFullScreen: [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
            DeviceOrientation.portraitUp
          ],
        );
      });
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _player.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  VideoPlayerController get _controller => _player.controller;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return _player.isInitialized && _chewieController != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Chewie(controller: _chewieController!),
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
