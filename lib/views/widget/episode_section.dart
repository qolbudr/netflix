import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix/models/episode_model.dart';
import 'package:netflix/models/tmdb_model.dart';

class EpisodeSection extends StatelessWidget {
  const EpisodeSection({super.key, required this.data, required this.episodes, required this.play});
  final List<Episodes> episodes;
  final Function({int? episode}) play;
  final Tmdb data;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        Episodes episode = episodes[index];
        return GestureDetector(
          onTap: () => play(episode: index + 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w200/${episode.stillPath}',
                    width: 120,
                    errorWidget: (context, url, error) => Opacity(
                      opacity: 0.3,
                      child: Image.asset(
                        'assets/images/placeholder.png',
                        width: 120,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(episode.name!),
                        Text('${episode.runtime} mins', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4))),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Text(episode.overview!, maxLines: 2, style: const TextStyle(fontSize: 12))
            ],
          ),
        );
      },
    );
  }
}
