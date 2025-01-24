import 'package:flutter/material.dart';

import 'print_job_service.dart'; // Import the PrintJobService file

class PrintPreferencesScreen extends StatefulWidget {
  @override
  _PrintPreferencesScreenState createState() => _PrintPreferencesScreenState();
}

class _PrintPreferencesScreenState extends State<PrintPreferencesScreen> {
  final TextEditingController _startPageController = TextEditingController();
  final TextEditingController _endPageController = TextEditingController();
  final TextEditingController _copiesController = TextEditingController();
  final TextEditingController _fileUrlController = TextEditingController();

  int _selectedPaperSize = 1; // 1: A4, 2: A3, etc.
  int _selectedSides = 1; // 1: Front Only, 2: Both Sides, etc.
  bool _isColor = true; // Color preference

  final List<String> _paperSizes = ["A4", "A3", "Legal", "Letter"];
  final List<String> _sidesOptions = ["Front Only", "Both Sides", "Even Sides", "Odd Sides"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Print Preferences"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Start and End Page Input
              TextField(
                controller: _startPageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Start Page"),
              ),
              TextField(
                controller: _endPageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "End Page"),
              ),

              // Copies Input
              TextField(
                controller: _copiesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Copies"),
              ),

              // File URL Input
              TextField(
                controller: _fileUrlController,
                decoration: InputDecoration(labelText: "File URL"),
              ),

              SizedBox(height: 20),

              // Paper Size Dropdown
              DropdownButtonFormField<int>(
                value: _selectedPaperSize,
                items: List.generate(
                  _paperSizes.length,
                      (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text(_paperSizes[index]),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedPaperSize = value!;
                  });
                },
                decoration: InputDecoration(labelText: "Paper Size"),
              ),

              // Sides Dropdown
              DropdownButtonFormField<int>(
                value: _selectedSides,
                items: List.generate(
                  _sidesOptions.length,
                      (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text(_sidesOptions[index]),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedSides = value!;
                  });
                },
                decoration: InputDecoration(labelText: "Print Sides"),
              ),

              // Color Toggle
              SwitchListTile(
                title: Text("Print in Color"),
                value: _isColor,
                onChanged: (value) {
                  setState(() {
                    _isColor = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  // Validate Input
                  if (_startPageController.text.isEmpty ||
                      _endPageController.text.isEmpty ||
                      _copiesController.text.isEmpty ||
                      _fileUrlController.text.isEmpty) {
                    PrintJobService.showSnackBar(context, "Please fill in all fields.");
                    return;
                  }

                  // Trigger Print Job
                  PrintJobService.processPrintJob(
                    context: context,
                    startPage: int.parse(_startPageController.text),
                    endPage: int.parse(_endPageController.text),
                    copies: int.parse(_copiesController.text),
                    isColor: _isColor,
                    selectedPaperSize: _selectedPaperSize,
                    selectedSides: _selectedSides,
                    printerOptions: [], // Add specific printer options if needed
                    fileUrl: _fileUrlController.text,
                  );
                },
                child: Text("Submit Print Job"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
