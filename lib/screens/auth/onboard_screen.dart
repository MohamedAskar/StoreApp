import 'package:flutter/material.dart';
import 'package:sk_onboarding_screen/sk_onboarding_model.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';
import 'package:store/screens/auth/sign_in_screen.dart';
import 'package:store/screens/auth/sign_up_screen.dart';

class OnboardScreen extends StatelessWidget {
  final pages = [
    SkOnboardingModel(
        title: 'Choose your Items',
        description:
            'Easily find your items and you will get delivery in wide range',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/onboard1.png'),
    SkOnboardingModel(
        title: 'Track your Order',
        description:
            'You can track your orders anytime, anywhere with descriptive details',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/onboard2.png'),
    SkOnboardingModel(
        title: 'Get your Order',
        description:
            'Pick up you order from the nearst store or get it delivered right in front of your door',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/onboard3.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SKOnboardingScreen(
        bgColor: Colors.white,
        themeColor: const Color(0xFF000000),
        pages: pages,
        skipClicked: (value) {
          Navigator.of(context).push(PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 150),
              opaque: false,
              pageBuilder: (_, animation1, __) {
                return SlideTransition(
                    position:
                        Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                            .animate(animation1),
                    child: SignInScreen());
              }));
        },
        getStartedClicked: (value) {
          Navigator.of(context).push(PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 150),
              opaque: false,
              pageBuilder: (_, animation1, __) {
                return SlideTransition(
                    position:
                        Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                            .animate(animation1),
                    child: SignUpScreen());
              }));
        },
      ),
    );
  }
}
