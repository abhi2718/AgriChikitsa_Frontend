import 'dart:async';

import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends HookWidget {
  final String? path;
  final String filename;
  PDFScreen({super.key, required this.path, required this.filename});
  final Completer<PDFViewController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    final pages = useState(0);
    return Scaffold(
      backgroundColor: AppColor.pdfBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.pdfBgColor,
        foregroundColor: AppColor.whiteColor,
        title: Text(filename),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PDFView(
          filePath: path,
          fitEachPage: false,
          autoSpacing: false,
          fitPolicy: FitPolicy.WIDTH,
        ),
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages.value ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages.value ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
