import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/models/tmdb_model.dart';
import 'package:remixicon/remixicon.dart';

class MovieSummary extends StatelessWidget {
  const MovieSummary({super.key, required this.data, required this.play, required this.isLoading});
  final Tmdb data;
  final Function({int? episode}) play;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w200/${data.posterPath}',
          width: 120,
          placeholder: (_, url) => AspectRatio(
            aspectRatio: 0.71,
            child: Container(
              width: 120,
              color: bgColor,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${data.voteCount} Vote',
              style: const TextStyle(color: Color(0xff46D267)),
            ),
            const SizedBox(width: 15),
            Text(
              data.firstAirDate == null ? 'N/A' : data.firstAirDate.toString().substring(0, 4),
              style: TextStyle(color: Colors.white.withOpacity(0.4)),
            ),
            const SizedBox(width: 15),
            Text(
              'N/A',
              style: TextStyle(color: Colors.white.withOpacity(0.4)),
            ),
            const SizedBox(width: 15),
            Text(
              data.runtime == null ? 'N/A' : '${data.runtime!.toInt()}min',
              style: TextStyle(color: Colors.white.withOpacity(0.4)),
            ),
          ],
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: defaultButton,
          onPressed: () => data.numberOfSeasons != null ? play(episode: 1) : play(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Remix.play_fill),
              const SizedBox(width: 10),
              const Text("Play"),
            ],
          ),
        ),
      ],
    );
  }
}
