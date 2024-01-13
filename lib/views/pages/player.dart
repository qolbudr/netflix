import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:netflix/constant.dart';
import 'package:netflix/models/tmdb_model.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final PlayerArgument argument = Get.arguments;
  late BetterPlayerController _betterPlayerController;
  final BetterPlayerConfiguration _configuration = BetterPlayerConfiguration(
    deviceOrientationsAfterFullScreen: [
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ],
    fit: BoxFit.contain,
    autoPlay: true,
    autoDetectFullscreenDeviceOrientation: true,
    showPlaceholderUntilPlay: true,
    subtitlesConfiguration: const BetterPlayerSubtitlesConfiguration(
      fontSize: 18,
      backgroundColor: Colors.black,
    ),
    controlsConfiguration: BetterPlayerControlsConfiguration(
      enableFullscreen: false,
      playerTheme: BetterPlayerTheme.material,
      showControlsOnInitialize: false,
      overflowModalColor: bgColor,
      overflowModalTextColor: Colors.white,
      overflowMenuIconsColor: Colors.white,
    ),
  );

  @override
  void initState() {
    super.initState();
    final source = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      argument.url,
      headers: {'range': 'bytes=0-'},
      videoFormat: argument.url.contains('m3u8') ? BetterPlayerVideoFormat.hls : null,
      cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
      subtitles: [
        BetterPlayerSubtitlesSource(
          type: BetterPlayerSubtitlesSourceType.memory,
          content: argument.subtitle,
          selectedByDefault: true,
        ),
      ],
    );
    _betterPlayerController = BetterPlayerController(_configuration);
    _betterPlayerController.setupDataSource(source);
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BetterPlayer(controller: _betterPlayerController),
    );
  }
}

class PlayerArgument {
  final String url;
  final String? subtitle;
  final Tmdb movie;
  PlayerArgument({required this.url, required this.subtitle, required this.movie});
}
