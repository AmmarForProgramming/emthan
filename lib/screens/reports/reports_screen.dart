import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التقارير", style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple.shade700,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "صفحة التقارير",
          style: GoogleFonts.tajawal(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple.shade800),
        ),
      ),
    );
  }
}