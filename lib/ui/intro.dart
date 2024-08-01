import 'package:flutter/material.dart';
import 'package:pdftopng/utils/ui_utils.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> with SingleTickerProviderStateMixin {
  bool isVisible1 = false;
  bool isVisible2 = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 300))
          .then((value) => setState(() => isVisible1 = true));
      Future.delayed(const Duration(milliseconds: 1800))
          .then((value) => setState(() => isVisible2 = true));
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: isVisible1 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1500),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Hey ! Hope you are having a great day. Let's convert your PDFs to PNGs.",
                    style: GoogleFonts.roboto(
                      fontSize: width * 0.1,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: height * 0.05,
                right: width * 0.05,
                child: AnimatedOpacity(
                  opacity: isVisible2 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 1500),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      color: Colors.amberAccent,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(height * 0.04)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.picture_as_pdf_sharp,
                              size: height * 0.04,
                            ),
                            SizedBox(width: width * 0.04),
                            Text(
                              "Upload\nPDF",
                              style: GoogleFonts.roboto(
                                fontSize: width * 0.07,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
