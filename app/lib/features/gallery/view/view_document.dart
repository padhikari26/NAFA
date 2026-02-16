import 'package:flutter/material.dart';
import 'package:file_saver/file_saver.dart';
import 'package:nafausa/app/utils/app_colors.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/shared/widgets/custom_scaffold.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../env.dart';
import '../../../shared/services/image_service.dart';

class ViewDocuments extends StatefulWidget {
  final String? file;
  final String? name;
  final String? title;

  const ViewDocuments({
    super.key,
    this.file,
    this.name,
    this.title,
  });

  @override
  State<ViewDocuments> createState() => _ViewDocumentsState();
}

class _ViewDocumentsState extends State<ViewDocuments> {
  // late PdfController pdfController;
  double downloadPercentage = 0.0;
  bool isLoading = false;
  bool pdfLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    Helper.requestStoragePermissions();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        showBackButton: true,
        title: widget.title ?? 'View Document',
        body: isError
            ? const Center(
                child: Text("Some error occurred"),
              )
            : Column(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      isLoading
                          ? const SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(
                                  child: CircularProgressIndicator.adaptive()),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.nepalBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                ImageService.startDownload(
                                  name: widget.name ?? "",
                                  ext: 'pdf',
                                  url: "${AppEnviro.imageUrl}/${widget.file}",
                                  mimeType: MimeType.pdf,
                                ).then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              },
                              child: const Text('Download',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                    ],
                  ),
                ),
                pdfLoading
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : widget.file.toString().contains('undefined')
                        ? const Center(
                            child: Text('No file available'),
                          )
                        : Expanded(
                            child: SfPdfViewer.network(
                              "${AppEnviro.imageUrl}/${widget.file}",
                            ),
                          )
              ]));
  }
}
