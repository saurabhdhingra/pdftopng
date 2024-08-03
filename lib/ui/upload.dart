import 'package:flutter/material.dart';
import 'package:pdftopng/ui/images.dart';
import 'package:pdftopng/utils/ui_utils.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  String? _pickedFilePath;

  bool isTransiton = false;

  bool isVisible1 = false;
  bool isVisible2 = false;

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pickedFilePath = result.files.single.path;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 300))
          .then((value) => setState(() => isVisible1 = true));
      Future.delayed(const Duration(milliseconds: 1800))
          .then((value) => setState(() => isVisible2 = true));
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation1 = Tween(begin: 0.0, end: 1000.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.ease),
      ),
    );
    _animation2 = Tween(begin: 0.0, end: 1000.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.ease),
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
          child: SizedBox(
            height: height * 0.9,
            width: width,
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_animation1.value + height * 0.35),
                      child: AnimatedOpacity(
                        opacity: isVisible1 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1500),
                        child: Padding(
                          padding: EdgeInsets.all(width * 0.05),
                          child: SizedBox(
                            width: width * 0.9,
                            child: Text(
                              _pickedFilePath == null
                                  ? isTransiton
                                      ? "Pick the new PDF"
                                      : "Hey ! Let's convert your PDFs to PNGs."
                                  : 'File picked : ${_pickedFilePath!.split('/').last}',
                              style: GoogleFonts.roboto(
                                fontSize: width * 0.08,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
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
                      offset: Offset(
                          _animation2.value + width * 0.51, height * 0.8),
                      child: AnimatedOpacity(
                        opacity: isVisible2 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1500),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              _pickedFilePath == null
                                  ? _pickPDF()
                                  : _controller.forward().then(
                                      (value) async {
                                        bool? result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImagesView(
                                              pdfPath: _pickedFilePath!,
                                            ),
                                          ),
                                        );
                                        setState(() {
                                          isTransiton = result ?? false;
                                          _pickedFilePath = null;
                                          _controller.reverse();
                                        });
                                      },
                                    );
                            },
                            child: SizedBox(
                              width: width * 0.42,
                              child: Card(
                                elevation: 5,
                                color: const Color(0xFFFEFAE0),
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(height * 0.04)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _pickedFilePath == null
                                            ? Icons.picture_as_pdf_sharp
                                            : Icons.image,
                                        size: height * 0.04,
                                      ),
                                      SizedBox(width: width * 0.04),
                                      Text(
                                        _pickedFilePath == null
                                            ? "Upload"
                                            : "Convert",
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
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
