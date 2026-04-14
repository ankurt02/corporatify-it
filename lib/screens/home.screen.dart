import 'package:corporate_filter/core/logger.dart';
import 'package:flutter/material.dart';

// Note: If you want to use actual SVGs, add 'flutter_svg: ^2.0.0' (or latest)
// to your pubspec.yaml and uncomment the import below.
// import 'package:flutter_svg/flutter_svg.dart';

import 'employee.screen.dart';
import 'hr.screen.dart';
import 'manager.screen.dart';
import '../widgets/qcard.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// 🔥 ADDED: SingleTickerProviderStateMixin for the AnimationController
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? selectedOption;

  // 🔥 ADDED: Animation Controller for the continuous scroll
  late AnimationController _scrollController;

  @override
  void initState() {
    super.initState();
    // Duration controls the speed of the scroll. Lower = faster.
    _scrollController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Loops indefinitely
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void handleProceed() {
    if (selectedOption == null) return;

    Widget nextScreen;

    if (selectedOption == 'a') {
      nextScreen = ScreenA();
    } else if (selectedOption == 'b') {
      nextScreen = ScreenB();
    } else {
      nextScreen = ScreenC();
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    logger.v("Inside build", tag: "in-BUILD");
    logger.e("NO ERROR", tag: "CHECK");
    logger.d("SOMETING", tag: "D-TAG");
    logger.w("CHECKING", tag: "WARNING-TAG");
    logger.i("CHecking I", tag: "I-TAG");

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Background Strips (Static Cross Pattern, but animating content)
          Positioned.fill(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Strip 1: Tilted downwards, scrolling Left
                Transform.translate(
                  offset: Offset(0, screenHeight * 0.35),
                  child: Transform.rotate(
                    angle: 0.05,
                    child: buildStrip(screenWidth, isMovingLeft: true),
                  ),
                ),
                // Strip 2: Tilted upwards, scrolling Right
                Transform.translate(
                  offset: Offset(0, screenHeight * 0.35),
                  child: Transform.rotate(
                    angle: -0.05,
                    child: buildStrip(screenWidth, isMovingLeft: false),
                  ),
                ),
              ],
            ),
          ),

          /// Foreground UI (Cards)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OptionCard(
                  text: "Are you a Manager?",
                  isSelected: selectedOption == 'a',
                  onTap: () => setState(() => selectedOption = 'a'),
                ),
                OptionCard(
                  text: "Are you HR?",
                  isSelected: selectedOption == 'b',
                  onTap: () => setState(() => selectedOption = 'b'),
                ),
                OptionCard(
                  text: "Are you an Employee?",
                  isSelected: selectedOption == 'c',
                  onTap: () => setState(() => selectedOption = 'c'),
                ),

                SizedBox(height: 20),

                GestureDetector(
                  onTap: handleProceed,
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Proceed",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Green Strip with Carousel Animation
  Widget buildStrip(double screenWidth, {required bool isMovingLeft}) {
    // Ensure all your text, icons, and spacing fit comfortably within this width.
    const double itemWidth = 350.0;

    return Container(
      width: screenWidth * 2.5,
      height: 55,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Color(0xFFC6FF00), // Neon green
      ),
      child: OverflowBox(
        maxWidth: double.infinity,
        child: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            double dx = isMovingLeft
                ? -itemWidth * _scrollController.value
                : -itemWidth + (itemWidth * _scrollController.value);

            return Transform.translate(
              offset: Offset(dx, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Generate enough items to fill the wide container
                children: List.generate(
                  20,
                  (index) => SizedBox(
                    width:
                        itemWidth, // Force the repeating block to be exactly this wide
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 1. Standard Flutter Icon
                        const Icon(Icons.flare, color: Colors.black, size: 20),

                        // 2. Text
                        const Text(
                          "YOUR TEXT",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),

                        // 3. PNG Image or SVG Placeholder
                        // If using flutter_svg, replace this Icon with:
                        // SvgPicture.asset('assets/my_icon.svg', width: 20, height: 20),
                        const Icon(Icons.bolt, color: Colors.black, size: 20),

                        // 4. More Text
                        const Text(
                          "WITH ICONS",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
