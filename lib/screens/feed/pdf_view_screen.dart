import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFViewScreen extends StatefulWidget {
  static const routeName = '/pdfview';

  @override
  _PDFViewScreenState createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  Color _color;
  bool _isLoading = true;
  bool code = false;
  String passValue = "";
  PdfController _pdfController;

  getDocument() async {
    _pdfController = PdfController(
      document: PdfDocument.openAsset(passValue),
      initialPage: 1,
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).primaryColor;
    passValue = ModalRoute.of(context).settings.arguments as String;

    if (!code) {
      code = !code;
      getDocument();
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "PDF View",
          style: TextStyle(color: _color),
        ).tr(),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: _color),
        actions: [
          IconButton(
              icon: Icon(
                Icons.file_download,
                color: _color,
              ),
              onPressed: () async {
                final status = await Permission.storage.request();

                if (status.isGranted) {
                  final externalDir = await getExternalStorageDirectory();
                  await FlutterDownloader.enqueue(
                    url: passValue,
                    savedDir: externalDir.path,
                    showNotification: true,
                    openFileFromNotification: true,
                  );
                }
              })
        ],
      ),
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PdfView(
                documentLoader: Center(child: CircularProgressIndicator()),
                pageLoader: Center(child: CircularProgressIndicator()),
                controller: _pdfController,
                onDocumentLoaded: (document) {},
                onPageChanged: (page) {},
              ),
      ),
    );
  }
}
