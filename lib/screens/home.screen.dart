import 'package:corporate_filter/core/logger.dart';
import 'package:corporate_filter/widgets/status.bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'employee.screen.dart';
import 'hr.screen.dart';
import 'manager.screen.dart';
import '../widgets/qcard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      nextScreen = ManagerScreen();
    } else if (selectedOption == 'b') {
      logger.d('Routing to HRScreen (ScreenB)', tag: 'HOME');
      nextScreen = HRScreen();
    } else {
      logger.d('Routing to EmployeeScreen (ScreenC)', tag: 'HOME');
      nextScreen = EmployeeScreen();
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: Offset(0, screenHeight * 0.35),
                  child: Transform.rotate(
                    angle: 0.05,
                    child: buildStrip(screenWidth, isMovingLeft: true),
                  ),
                ),
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
                  child: StatusBarWidget(),
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
