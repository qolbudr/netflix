import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      placeholder: CachedNetworkImage(imageUrl: 'https://image.tmdb.org/t/p/w500/${argument.movie.backdropPath}'),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        Navigator.popUntil(context, (route) => route.settings.name == "/detail");
      },
      child: Material(
        child: BetterPlayer(controller: _betterPlayerController),
      ),
    );
  }
}

class PlayerArgument {
  final String url;
  final String? subtitle;
  final Tmdb movie;
  PlayerArgument({required this.url, required this.subtitle, required this.movie});
}
