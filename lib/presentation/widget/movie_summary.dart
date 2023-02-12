import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:remixicon/remixicon.dart';

class MovieSummary extends StatelessWidget {
  const MovieSummary({super.key, required this.data, required this.play});
  final Movie data;
  final Function(String, {String? subtitle}) play;
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
              data.quality ?? 'N/A',
              style: TextStyle(color: Colors.white.withOpacity(0.4)),
            ),
            const SizedBox(width: 15),
            Text(
              data.runtime == null ? 'N/A' : data.runtime.toString(),
              style: TextStyle(color: Colors.white.withOpacity(0.4)),
            ),
          ],
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: defaultButton,
          onPressed: () => 
            (data.season != null) ?
              play('https://database.gdriveplayer.us/player.php?type=series&imdb=${data.imdb}&season=${data.season}&episode=1') :
              play('https://database.gdriveplayer.us/player.php?imdb=${data.imdb}'), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Remix.play_fill),
              SizedBox(width: 10),
              Text("Play")
            ],
          ),
        ),
      ],
    );
  }
}