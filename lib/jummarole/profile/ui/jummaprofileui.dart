import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JummaProfileUI extends StatelessWidget {
  const JummaProfileUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 64, color: Color(0xFF436E50)),
            const SizedBox(height: 16),
            Text(
              'Jumma Profile',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3436),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
