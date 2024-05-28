import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    // Calcula las estrellas llenas
    int fullStars = rating.floor();
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow));
    }

    // Calcula la fracción de estrella
    double fraction = rating - fullStars;
    if (fraction > 0) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow));
    }

    // Añade las estrellas vacías restantes
    int emptyStars = 5 - stars.length;
    for (int i = 0; i < emptyStars; i++) {
      stars.add(Icon(Icons.star_border, color: Colors.yellow));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }
}