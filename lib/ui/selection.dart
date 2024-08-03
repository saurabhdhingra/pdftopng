import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show rootBundle;

class Selection extends StatefulWidget {
  final Uint8List imageData;
  final String imageName;
  const Selection(
      {super.key, required this.imageData, required this.imageName});

  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  void _shareImage() async {
    final file = XFile.fromData(
      widget.imageData,
      mimeType: 'image/png',
      name: widget.imageName,
    );
    await Share.shareXFiles([file]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.imageName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(tag: widget.imageName, child: Image.memory(widget.imageData)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _shareImage,
              child: const Text('Share Image'),
            ),
          ],
        ),
      ),
    );
  }
}
