import 'package:flutter/material.dart';
import 'package:quick/constant/colors.dart';
import 'package:quick/data/onboarding_data.dart';
import 'package:quick/screens/onboarding/front_page.dart';
import 'package:quick/screens/onboarding/shared_onboarding_screen.dart';
import 'package:quick/screens/user_data_scren.dart';
import 'package:quick/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool showDetailsPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      showDetailsPage = index == 3;
                      print(showDetailsPage);
                    });
                  },
                  children: [
                    FrontPage(),
                    SharedOnboardingScreen(
                      title: onboardingData.onboardingList[0].title,
                      imagePath: onboardingData.onboardingList[0].imagePath,
                      description: onboardingData.onboardingList[0].description,
                      subTitle: onboardingData.onboardingList[0].subTitle,
                      subDescription: onboardingData.onboardingList[0].SubDescription,
                      subImagePath: onboardingData.onboardingList[0].SubImagePath,
                    ),
                    SharedOnboardingScreen(
                      title: onboardingData.onboardingList[1].title,
                      imagePath: onboardingData.onboardingList[1].imagePath,
                      description: onboardingData.onboardingList[1].description, 
                      subTitle: onboardingData.onboardingList[1].subTitle,
                      subDescription: onboardingData.onboardingList[1].SubDescription,
                      subImagePath: onboardingData.onboardingList[1].SubImagePath,
                    ),
                    SharedOnboardingScreen(
                      title: onboardingData.onboardingList[2].title,
                      imagePath: onboardingData.onboardingList[2].imagePath,
                      description: onboardingData.onboardingList[2].description, 
                      subTitle: onboardingData.onboardingList[2].subTitle,
                      subDescription: onboardingData.onboardingList[2].SubDescription,
                      subImagePath: onboardingData.onboardingList[2].SubImagePath,
                    ),
                  ],
                ),

                //page dot indicator
                Container(
                  alignment: const Alignment(0,0.75),
                  //padding: const EdgeInsets.only(bottom: 90),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                    effect: const WormEffect(
                      activeDotColor: const Color(0xFFEC5F18),
                      dotColor: Color.fromARGB(255, 214, 206, 201),
                    ),
                  ),
                ),


                //navigation button
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ! showDetailsPage ? GestureDetector(
                      onTap: () {
                        _controller.animateToPage(
                          _controller.page!.toInt() +1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: CustomButton(
                        buttonColor: buttonColor,
                        buttonName: showDetailsPage ? "Get Started" : "Next",
                      ),
                    )
                    : GestureDetector(
                      onTap: () {
                            //Navigate to the user dater screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDateScreen(), 
                              ),
                            );
                      },
                      child: CustomButton(
                        buttonColor: buttonColor,
                        buttonName: showDetailsPage ? "Get Started" : "Next",
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
}