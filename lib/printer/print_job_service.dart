import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';  // For PdfPageFormat

class PrintJobService {
  /// Processes the print job with the given parameters.
  static Future<void> processPrintJob({
    required BuildContext context,
    required int startPage,
    required int endPage,
    required int copies,
    required bool isColor,
    required int selectedPaperSize,
    required int selectedSides,
    required List<String> printerOptions,
    required String fileUrl,
  }) async {
    try {
      // Log the job details to the console
      debugPrint("Processing Print Job:");
      debugPrint("Start Page: $startPage");
      debugPrint("End Page: $endPage");
      debugPrint("Copies: $copies");
      debugPrint("Color: $isColor");
      debugPrint("Paper Size: $selectedPaperSize");
      debugPrint("Sides: $selectedSides");
      debugPrint("File URL: $fileUrl");
      debugPrint("Printer Options: ${printerOptions.join(', ')}");

      // Download the file from the URL as a byte array
      Uint8List fileData = await _downloadFile(fileUrl);

      // Send the print job to the printer with preferences
      await _printFile(
        fileData,
        startPage,
        endPage,
        copies,
        isColor,
        selectedSides,
        selectedPaperSize, // Include paper size here
      );

      // Show a snackbar for successful processing
      showSnackBar(context, "Print job sent successfully.");
    } catch (e) {
      // Show error message in snackbar
      showSnackBar(context, "Error: $e");
    }
  }

  /// Downloads the file from the given URL and returns the file as byte data.
  static Future<Uint8List> _downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Return the file as byte data (no need to save locally)
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download file');
    }
  }

  /// Sends the file data to the printer with given preferences.
  static Future<void> _printFile(
      Uint8List fileData,
      int startPage,
      int endPage,
      int copies,
      bool isColor,
      int selectedSides,
      int selectedPaperSize, // Include paper size here
      ) async {
    // Send the print job for each copy
    for (int i = 0; i < copies; i++) {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          // Logic to return only selected pages from file data
          // Depending on startPage and endPage, slice or adjust the PDF data here

          // For now, we are directly returning the entire file data
          // but you can use a library like `pdf` or `pdf_image_renderer` to extract specific pages
          return fileData;
        },
        format: PdfPageFormat.a4, // Adjust paper size as needed
      );
    }
  }

  /// Displays a snackbar with the given message.
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
