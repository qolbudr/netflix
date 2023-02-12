import "package:flutter/material.dart";
import 'package:netflix/data/model/home_model.dart';
import 'package:netflix/presentation/widget/card_newest.dart';

class SectionNewest extends StatelessWidget {
  const SectionNewest({super.key, required this.data});
  final List<Movie> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Movies & TV", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        const SizedBox(height: 15),
        Column(
          children: List.generate(
            data.length, (index) {
              Movie movie = data[index];
              return CardNewest(movie: movie);
            }
          ),
        )
      ],
    );
  }
}