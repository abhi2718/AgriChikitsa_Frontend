import 'dart:typed_data';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../res/color.dart';
import 'helper/save_file_helper.dart';

class SoilTestingReportScreen extends HookWidget {
  const SoilTestingReportScreen({super.key, required this.fieldId});
  final String fieldId;
  @override
  Widget build(BuildContext context) {
    final useViewModel = useMemoized(() => Provider.of<AGPlusViewModel>(context, listen: false));
    useEffect(() {
      useViewModel.getSoilReportsList(context, fieldId, 1);
    }, [fieldId]);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColor.darkBlackColor,
        elevation: 0.0,
        title: Text(
          AppLocalization.of(context).getTranslatedValue("reportButton").toString(),
          style: const TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent &&
              !useViewModel.isReportsLoading &&
              useViewModel.currentReportsPage < useViewModel.totalReportsPages) {
            useViewModel.getSoilReportsList(context, fieldId, useViewModel.currentReportsPage++);
          }
          return false;
        },
        child: Consumer<AGPlusViewModel>(
          builder: (context, provider, child) {
            if (provider.isReportsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColor.extraDark));
            }
            if (provider.reportsList.isEmpty) {
              return Center(
                  child: Text(
                      AppLocalization.of(context).getTranslatedValue("noReportFound").toString()));
            }

            return ListView.builder(
              itemCount: provider.reportsList.length + (provider.isReportsLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.reportsList.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final report = provider.reportsList[index];
                return _buildReportTile(context, report);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildReportTile(BuildContext context, Map<String, dynamic> report) {
    final String testId = report['testId'];
    final String status = report['status'];
    final String cropName = report['cropName'];
    final String sampleDate = report['sampleDate'];
    final DateTime formattedDate = DateTime.parse(sampleDate);
    final String formattedDateString = DateFormat('dd/MM/yy h:mm a').format(formattedDate);
    return InkWell(
      onTap: () => {launchUrl(Uri.parse("https://agrichikitsa.org/soilreport/${report['_id']}"))},
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(offset: Offset(2, 2), color: Colors.black45)],
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColor.extraDark,
                    ),
                  ),
                  Text(
                    '${AppLocalization.of(context).getTranslatedValue("plotCropTitle").toString()}: $cropName',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sample Date: $formattedDateString',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (status == 'TESTED')
              RawMaterialButton(
                onPressed: () =>
                    {launchUrl(Uri.parse("https://agrichikitsa.org/soilreport/${report['_id']}"))},
                elevation: 2.0,
                fillColor: AppColor.extraDark,
                constraints: BoxConstraints(minHeight: 0, minWidth: 0),
                padding: EdgeInsets.all(12.0),
                shape: CircleBorder(),
                child: Icon(
                  Icons.description,
                  size: 22.0,
                  color: AppColor.whiteColor,
                ),
              )
            else
              Text(
                status,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> createInvoice() async {
    final PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      await generateInvoice();
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  Future<void> generateInvoice() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    // page.graphics.drawRectangle(
    //     bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
    //     pen: PdfPen(PdfColor(142, 170, 219)));
    //Generate PDF grid.
    // final PdfGrid grid = getGrid();
    // //Draw the header section by creating text element
    final PdfLayoutResult result = await drawHeader(page, pageSize);
    // //Draw grid
    // drawGrid(page, grid, result);
    // //Add invoice footer
    // drawFooter(page, pageSize);
    //Save the PDF document
    final List<int> bytes = document.saveSync();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.
    await saveAndLaunchFile(bytes, 'ReportTitle.pdf');
  }

  Future<PdfLayoutResult> drawHeader(PdfPage page, Size pageSize) async {
    //Draw rectangle
    // page.graphics.drawRectangle(
    //     brush: PdfSolidBrush(PdfColor(91, 126, 215)),
    //     bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    // final Uint8List imageData = File('assets/images/logoagrichikitsa.png').readAsBytesSync();
    final ByteData imageData = await rootBundle.load('assets/images/logoagrichikitsa.png');
    final Uint8List imageBytes = imageData.buffer.asUint8List();
//Load the image using PdfBitmap.
    final PdfBitmap image = PdfBitmap(imageBytes);
    page.graphics.drawImage(image, const Rect.fromLTWH(0, 0, 60, 60));

    final font = await rootBundle.load("assets/fonts/Hind-Regular.ttf");
    final Uint8List fontBytes = font.buffer.asUint8List();
    final PdfFont customFont = PdfTrueTypeFont(fontBytes, 9);
    // final ttf = pw.Font.ttf(font);
    // final font1 = PdfFontF;

    // final PdfFont contentFont = PdfStandardFont(fontBytes, 9);
    page.graphics.drawString('फसलों की सुरक्षा', customFont,
        brush: PdfBrushes.green,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.bottom));
    page.graphics.drawString('एग्रिचिकित्सा', customFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(400, 16, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber =
        'Invoice Number: 2058557939\r\n\r\nDate: ${format.format(DateTime.now())}';
    final Size contentSize = customFont.measureString(invoiceNumber);
    // ignore: leading_newlines_in_multiline_strings
    const String address = '''Bill To: \r\n\r\nAbraham Swearegin, 
        \r\n\r\nUnited States, California, San Mateo, 
        \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136''';

    PdfTextElement(text: invoiceNumber, font: customFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: address, font: customFont).draw(
        page: page,
        bounds: Rect.fromLTWH(
            30, 120, pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }
}
