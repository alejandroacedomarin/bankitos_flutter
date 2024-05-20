import 'package:flutter/material.dart';

class ProfileInformation extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInformation({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verifica si el valor no está vacío
    if (value.isEmpty) {
      // Si el valor está vacío, no muestra nada
      return SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10.0), // Espacio entre el label y el valor
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis, // Ajusta el texto si es demasiado largo
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}