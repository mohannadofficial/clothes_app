import 'dart:async';
import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/icon_button.dart';
import 'package:ecommerce_app/core/common/image_list_view.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/core/utils/utils.dart';
import 'package:ecommerce_app/features/auth/controller/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;

  List<String> title = [
    'Your Appearance \nShows Your Quality',
    'Buy',
    'Sell',
    'Chat',
  ];

  List<String> description = [
    'Change The Quality Of Your \n Appearance with Ryzne',
    'Shop from thousands of brands \n at throwaway prices!',
    'Click, List cool stuff to \n earn easy cash',
    'Chat for more info and bargain \n for a better price.'
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentIndex == 3) {
        timer.cancel();
      } else {
        setState(() {
          currentIndex++;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -10,
            left: -150,
            child: Row(
              children: const [
                ImageListView(startIndex: 0),
                ImageListView(startIndex: 1),
                ImageListView(startIndex: 2),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: const BigText(
              text: "Ryzne Shop",
              color: AppColors.backGroundColor,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white60,
                    Colors.white,
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title[currentIndex],
                    style: kNormalStyle.copyWith(fontSize: 30, height: 1.3),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    description[currentIndex],
                    style: kNormalStyle.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  AnimatedSmoothIndicator(
                    activeIndex: currentIndex,
                    count: 4,
                    axisDirection: Axis.horizontal,
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 150),
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.iconColor,
                    ),
                    onDotClicked: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (currentIndex >= 0 && currentIndex < 3)
            Positioned(
              bottom: 50,
              right: 20,
              child: IconButtonWidget(
                icon: IconlyLight.arrowRight,
                color: AppColors.iconColor,
                sizeIcon: 35,
                function: () {
                  setState(() {
                    currentIndex++;
                  });
                },
              ),
            ),
          if (currentIndex > 0 && currentIndex < 3)
            Positioned(
              bottom: 50,
              left: 20,
              child: IconButtonWidget(
                icon: IconlyLight.arrowLeft,
                color: AppColors.iconColor,
                sizeIcon: 35,
                function: () {
                  setState(() {
                    --currentIndex;
                  });
                },
              ),
            ),
          if (currentIndex == 3)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.iconColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () => sl<AuthCubit>().onBoarding(),
                  child: const Text("Sign Up with Email"),
                ),
              ),
            )
        ],
      ),
    );
  }
}
