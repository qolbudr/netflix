import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:remixicon/remixicon.dart';

class CardNewest extends StatelessWidget {
  const CardNewest({super.key, required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: movie),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w200/${movie.backdropPath}',
                width: 120,
                errorWidget: (context, url, error) => Opacity(
                  opacity: 0.3,
                  child: CachedNetworkImage(
                    imageUrl: 'https://wtwp.com/wp-content/uploads/2015/06/placeholder-image-300x225.png',
                    width: 120,
                  ),
                ),
                placeholder: (_, url) => AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    width: 120,
                    color: bgColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                movie.season == null ? movie.title! : '${movie.name} - Season ${movie.season}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white.withOpacity(0.8))
              ),
            ),
            const SizedBox(width: 15),
            const Icon(Remix.play_circle_line, size: 30)
          ],
        ),
      ),
    );
  }
}