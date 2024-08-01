import 'package:flutter/material.dart';
import 'package:pdftopng/ui/intro.dart';

import '../utils/ui_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool visible = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2))
        .then((value) => _navigateToNextPage());
  }

  void _navigateToNextPage() {
    setState(() => visible = false);
    Future.delayed(const Duration(milliseconds: 2100)).then(
      (value) => Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Intro(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInExpo,
          child: Card(
            elevation: 5,
            color: Colors.white,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height * 0.04),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: height * 0.01,
                vertical: height * 0.01,
              ),
              child: Container(
                height: height * 0.25,
                width: height * 0.25,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
