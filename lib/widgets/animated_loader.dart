import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/ui_utils.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';

class AnimatedLoader extends StatefulWidget {
  final String? label;
  final int? index;
  final double? height;
  final double? width;

  const AnimatedLoader(
      {super.key, this.label, this.index, this.height, this.width});

  @override
  State<AnimatedLoader> createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader> {
  int lottieIndex = 0;
  var rng = Random();

  @override
  void initState() {
    super.initState();

    if (widget.index != null) {
      lottieIndex = widget.index ?? 0;
    } else {
      lottieIndex = rng.nextInt(lotties.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: widget.width ?? width * 0.4,
          height: widget.height ?? width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.all(width * 0.03),
          child: Lottie.asset(
            lotties[lottieIndex],
            fit: BoxFit.contain,
            width: widget.width ?? width * 0.2,
            height: widget.height ?? width * 0.2,
          ),
        ),
        Text(
          widget.label ?? "",
          style: GoogleFonts.poppins(
            fontSize: width * 0.035,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

List<String> lotties = ["assets/loader.json"];
