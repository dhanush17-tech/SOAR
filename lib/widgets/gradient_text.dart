import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientText extends StatelessWidget {
  GradientText(
    this.text, {
    @required this.gradient,
  });

  final String text;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 30,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
