import "package:flutter/material.dart";
import 'package:netflix/models/tmdb_model.dart';
import 'package:remixicon/remixicon.dart';

class MovieInfo extends StatelessWidget {
  const MovieInfo({super.key, required this.data});
  final Tmdb data;
  // final MovieDetailModel detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        Text(data.overview ?? '-', maxLines: 3),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: Builder(builder: (_) {
            List<Cast> cast = (data.credits?.cast ?? []).where((item) => item.knownForDepartment == "Acting").toList();
            List<Cast> displayCast = cast.sublist(0, cast.length >= 3 ? 3 : cast.length);
            List casts = [];
            for (Cast item in displayCast) {
              casts.add(item.name);
            }
            return Text(casts.join(', '), style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4)));
          }),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Column(
              children: [GestureDetector(onTap: () {}, child: const Icon(Icons.add_outlined)), Text("My List", style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4)))],
            ),
            const SizedBox(width: 30),
            Column(
              children: [GestureDetector(onTap: () {}, child: const Icon(Remix.thumb_up_line)), Text("Rate", style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4)))],
            ),
            const SizedBox(width: 30),
            Column(
              children: [GestureDetector(onTap: () {}, child: const Icon(Remix.upload_2_line)), Text("Share", style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4)))],
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
