import "package:flutter/material.dart";
import 'package:netflix/data/model/home_model.dart';

class CardMovie extends StatelessWidget {
  const CardMovie({super.key, required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          'https://image.tmdb.org/t/p/w200/${movie.posterPath}',
          width: 120,
        ),
      ),
    );
  }
}