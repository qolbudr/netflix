import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/movie_model.dart';

class Player extends StatelessWidget {
  const Player({super.key, required this.argument});

  final PlayerArgument argument;

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
        child: BetterPlayer(
          controller: BetterPlayerController(
            BetterPlayerConfiguration(
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
            ),
            betterPlayerDataSource: BetterPlayerDataSource(
              BetterPlayerDataSourceType.network,
              argument.url,
              placeholder: CachedNetworkImage(imageUrl: 'https://image.tmdb.org/t/p/w500/${argument.movie.tmdb?.backdropPath}'),
              cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
              subtitles: [
                BetterPlayerSubtitlesSource(
                  type: BetterPlayerSubtitlesSourceType.memory,
                  content: argument.subtitle,
                  selectedByDefault: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerArgument {
  final String url;
  final String? subtitle;
  final Movie movie;
  PlayerArgument({required this.url, required this.subtitle, required this.movie});
}
