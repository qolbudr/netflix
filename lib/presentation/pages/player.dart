import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';

class Player extends StatelessWidget {
  const Player({super.key, required this.argument});

  final PlayerArgument argument;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BetterPlayer(
        controller: BetterPlayerController(
          BetterPlayerConfiguration(
            fit: BoxFit.contain,
            autoPlay: true,
            autoDetectFullscreenDeviceOrientation: true,
            showPlaceholderUntilPlay: true,
            subtitlesConfiguration: const BetterPlayerSubtitlesConfiguration(
              fontSize: 18,
              backgroundColor: Colors.black,
            ),
            controlsConfiguration: BetterPlayerControlsConfiguration(
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
            placeholder: CachedNetworkImage(imageUrl: 'https://image.tmdb.org/t/p/w500/${argument.movie.backdropPath}'),
            cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
            subtitles: [
              BetterPlayerSubtitlesSource(
                type: BetterPlayerSubtitlesSourceType.memory,
                content: argument.subtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerArgument {
  final String url;
  final String subtitle;
  final Movie movie;
  PlayerArgument({required this.url, required this.subtitle, required this.movie});
}
