import 'dart:async';

import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          // swipeHorizontal: true,
          // autoSpacing: true,
          // pageFling: true,
          // pageSnap: true,
          fitPolicy: FitPolicy.WIDTH,
          // defaultPage: currentPage!,
          // fitPolicy: FitPolicy.BOTH,
          // preventLinkNavigation:
          //     false, // if set to true the link is handled in flutter
          // onRender: (_pages) {
          //   setState(() {
          //     pages = _pages;
          //     isReady = true;
          //   });
          // },
          // onError: (error) {
          //   setState(() {
          //     errorMessage = error.toString();
          //   });
          //   print(error.toString());
          // },
          // onPageError: (page, error) {
          //   setState(() {
          //     errorMessage = '$page: ${error.toString()}';
          //   });
          //   print('$page: ${error.toString()}');
          // },
          // onViewCreated: (PDFViewController pdfViewController) {
          //   _controller.complete(pdfViewController);
          // },
          // onLinkHandler: (String? uri) {
          //   print('goto uri: $uri');
          // },
          // onPageChanged: (int? page, int? total) {
          //   print('page change: $page/$total');
          //   setState(() {
          //     currentPage = page;
          //   });
          // },
        ),
      ),
      // errorMessage.isEmpty
      //     ? !isReady
      //         ? Center(
      //             child: CircularProgressIndicator(),
      //           )
      //         : Container()
      //     : Center(
      //         child: Text(errorMessage),
      //       )),
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
