import 'package:corporate_filter/core/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'employee.screen.dart';
import 'hr.screen.dart';
import 'manager.screen.dart';
import '../widgets/qcard.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? selectedOption;

  late AnimationController _scrollController;

  // In initState():
  @override
  void initState() {
    super.initState();
    logger.i('HomeScreen mounted', tag: 'HOME');
    _scrollController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    logger.i('HomeScreen disposed', tag: 'HOME');
    _scrollController.dispose();
    super.dispose();
  }

  void handleProceed() {
    if (selectedOption == null) {
      logger.w('Proceed tapped but no option selected', tag: 'HOME');
      return;
    }

    logger.i('User selected option: $selectedOption — navigating', tag: 'HOME');

    Widget nextScreen;
    if (selectedOption == 'a') {
      logger.d('Routing to ManagerScreen (ScreenA)', tag: 'HOME');
      nextScreen = ScreenA();
    } else if (selectedOption == 'b') {
      logger.d('Routing to HRScreen (ScreenB)', tag: 'HOME');
      nextScreen = ScreenB();
    } else {
      logger.d('Routing to EmployeeScreen (ScreenC)', tag: 'HOME');
      nextScreen = ScreenC();
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                OptionCard(
                  text: "Are you a Manager?",
                  isSelected: selectedOption == 'a',
                  onTap: () => setState(() => selectedOption = 'a'),
                ),
                Gap(12),
                OptionCard(
                  text: "Are you HR?",
                  isSelected: selectedOption == 'b',
                  onTap: () => setState(() => selectedOption = 'b'),
                ),
                Gap(12),
                OptionCard(
                  text: "Are you an Employee?",
                  isSelected: selectedOption == 'c',
                  onTap: () => setState(() => selectedOption = 'c'),
                ),

                SizedBox(height: 32),

                GestureDetector(
                  onTap: handleProceed,
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Text(
                        "Proceed",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                // Gap(16),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  // decoration: BoxDecoration(
                    // color: Colors.grey.shade900,
                    // border: Border.all(
                    //   color: Colors.pinkAccent,
                    //   width: 2
                    // )
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Gap(12),
                          SvgPicture.asset(
                            "assets/svg/branch01.svg",
                            height: 16,
                            width: 10,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                  
                          Gap(6),
                  
                          Text(
                            "main*",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                          ),
                  
                          Gap(16),
                  
                          SvgPicture.asset(
                            "assets/svg/error01.svg",
                            height: 16,
                            width: 16,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          Gap(2),
                  
                          Text(
                            "0",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                          ),
                          Gap(6),
                  
                          SvgPicture.asset(
                            "assets/svg/warnings01.svg",
                            height: 16,
                            width: 16,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                  
                          Gap(2),
                  
                          Text(
                            "0",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                          ),
                  
                          Gap(6),
                  
                          SvgPicture.asset(
                            "assets/svg/warning02.svg",
                            height: 16,
                            width: 16,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                  
                          Gap(2),
                  
                          Text(
                            "0",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                  
                      Row(
                        children: [
                          Text(
                            "v1.0.2-release",
                            style: GoogleFonts.robotoMono(
                              fontSize: 12,
                              color: Colors.grey.shade300,
                              letterSpacing: 0,
                            ),
                          ),
                  
                          Gap(16),
                  
                          Text(
                            "host : github-pages",
                            style: GoogleFonts.robotoMono(
                              fontSize: 12,
                              color: Colors.grey.shade300,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Text(
                          //   "Spaces : 2",
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     color: Colors.white,
                          //     letterSpacing: 0,
                          //   ),
                          // ),
                          Gap(20),
                          Text(
                            "UTF-8",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                          ),
                  
                          Gap(20),
                          Text(
                            "CRLF",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                          ),
                  
                          Gap(20),
                  
                          SvgPicture.asset(
                            "assets/svg/curlybraces.svg",
                            height: 16,
                            width: 16,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                  
                          Gap(2),
                  
                          Text(
                            "Dart",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                          ),
                          Gap(12),
                        ],
                      ),
                    ],
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
      height: 45,
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
                children: List.generate(
                  20,
                  (index) => SizedBox(
                    width:
                        itemWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Standard Flutter Icon
                        const Icon(Icons.flare, color: Colors.black, size: 20),

                        // Text
                        const Text(
                          "CORPORATE CHAOS",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),

                        // PNG Image or SVG Placeholder
                        // If using flutter_svg, replace this Icon with:
                        // SvgPicture.asset('assets/my_icon.svg', width: 20, height: 20),
                        // const Icon(Icons.bolt, color: Colors.black, size: 20),

                        // More Text
                        const Text(
                          "•  FILTERED BY AI",
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
