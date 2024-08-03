import 'package:flutter/material.dart';
import 'package:pdftopng/utils/ui_utils.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:pdftopng/widgets/animated_loader.dart';
import 'package:pdfx/pdfx.dart';

import 'selection.dart';

class ImagesView extends StatefulWidget {
  final String pdfPath;
  const ImagesView({super.key, required this.pdfPath});

  @override
  State<ImagesView> createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;

  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  List images = [];

  Future<void> getImages(String? path) async {
    if (path != null) setState(() => isLoading = true);
    final document = await PdfDocument.openFile(widget.pdfPath);

    final length = document.pagesCount;

    for (int i = 1; i < length + 1; i++) {
      final page = await document.getPage(i);

      final image = await page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: PdfPageImageFormat.png,
        backgroundColor: '#ffffff',
      );

      images.add(image);

      page.close();
    }

    _controller.forward();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getImages(null);
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _animation1 = Tween(begin: 1000.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.decelerate),
      ),
    );
    _animation2 = Tween(begin: 1000.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.decelerate),
      ),
    );
    _animation3 = Tween(begin: 5.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.decelerate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const Center(child: AnimatedLoader())
              : SizedBox(
                  height: height * 0.9,
                  width: width,
                  child: Stack(
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(width * 0.05,
                                _animation1.value + height * 0.05),
                            child: SizedBox(
                              width: width * 0.9,
                              child: Text(
                                "Voila ! Click to expand",
                                style: GoogleFonts.roboto(
                                  fontSize: width * 0.08,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(width * 0.05,
                                _animation2.value + height * 0.12),
                            child: SizedBox(
                              height: height * 0.87,
                              width: width * 0.9,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: height * 0.1),
                                  child: Column(
                                    children: List.generate(
                                      2 * images.length,
                                      (index) {
                                        if (index == 2 * images.length - 1) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: height * 0.05,
                                              child: ElevatedButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: const Text(
                                                    'Convert another PDF'),
                                              ),
                                            ),
                                          );
                                        } else if (index % 2 != 0) {
                                          return AnimatedBuilder(
                                            animation: _controller,
                                            builder: (context, child) {
                                              return Transform.scale(
                                                scaleX: _animation3.value,
                                                child: SizedBox(
                                                  height: height * 0.03,
                                                ),
                                              );
                                            },
                                          );
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return Selection(
                                                    imageData: images[
                                                            (index / 2).floor()]
                                                        .bytes,
                                                    imageName: (index / 2)
                                                        .floor()
                                                        .toString(),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: (index / 2).floor().toString(),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.05)),
                                              elevation: 5,
                                              child: Container(
                                                width: width * 0.9,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.05),
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.05),
                                                  child: Image.memory(images[
                                                          (index / 2).floor()]
                                                      .bytes),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
