import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle smallTextStyle = GoogleFonts.montserrat(fontSize: 15);
TextStyle titleTextStyle =
    GoogleFonts.oswald(fontSize: 28, fontWeight: FontWeight.bold);


myStyleMontserrat(double fs, Color clr, [FontWeight ?fw]){
    return GoogleFonts.montserrat(fontSize: fs, color: clr, fontWeight: fw);
}