import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(title: Text("Screen A")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "We will get back to u later!",
              style: GoogleFonts.spaceMono(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: -0.2,
                wordSpacing: 0.2,
              ),
            ),
            Gap(32),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                "assets/images/bleeeeeeh.jpg",
                height: screenHeight / 3,
                width: screenHeight / 3,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
