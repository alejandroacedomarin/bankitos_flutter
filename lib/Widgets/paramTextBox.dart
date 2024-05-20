import 'package:flutter/material.dart';

class ParamTextBox extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final String? initialValue; // Nuevo parámetro para el valor inicial
  final bool obscureText; // Nuevo parámetro para ocultar el texto

  ParamTextBox({
    Key? key,
    required this.controller,
    required this.text,
    this.initialValue, // Agregar el nuevo parámetro aquí
    this.obscureText = false, // Establecer el valor predeterminado a false
  }) : super(key: key);

  @override
  _ParamTextBoxState createState() => _ParamTextBoxState();
}

class _ParamTextBoxState extends State<ParamTextBox> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    // Establecer el valor inicial del controlador de texto si initialValue no es nulo
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText, // Utiliza el valor actual de _obscureText
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.orange, // Cambia este color al que prefieras
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 1, 4),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 7, 4, 3),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: widget.text,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
