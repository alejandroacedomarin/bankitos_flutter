import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;

  const StarRating({
    Key? key,
    required this.initialRating,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0), // Ajuste de margen izquierdo
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centra las estrellas horizontalmente
        children: List.generate(5, (index) {
          double value = index + 1.0;
          return IconButton(
            onPressed: () {
              setState(() {
                _rating = value;
              });
              widget.onRatingChanged(value);
            },
            icon: Icon(
              Icons.star,
              size: 40.0, // Tamaño ajustado de las estrellas
              color: value <= _rating ? Colors.orange : Colors.grey[400],
            ),
          );
        }),
      ),
    );
  }
}
