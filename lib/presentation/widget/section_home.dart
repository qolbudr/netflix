import "package:flutter/material.dart";
import 'package:netflix/data/model/home_model.dart';
import 'package:netflix/presentation/widget/card_movie.dart';

class SectionHome extends StatelessWidget {
  const SectionHome({super.key, required this.data, required this.title});
  final List<Movie> data;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(data.length, (index) => 
                  CardMovie(movie: data[index])
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}