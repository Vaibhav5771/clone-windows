import 'package:chats_windows/printer/printer_list_page.dart';
import 'package:chats_windows/printer/printer_service.dart';
import 'package:flutter/material.dart';

class SavePrinterPage extends StatefulWidget {
  @override
  _SavePrinterPageState createState() => _SavePrinterPageState();
}

class _SavePrinterPageState extends State<SavePrinterPage> {
  final _formKey = GlobalKey<FormState>();
  String? printerName, printSpeed, activePower, idlePower, printTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Printer'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Center(
          child: Container(
            width: 600,
            height: 800,
            child: Card(
              elevation: 0,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Printer Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 15),
                      _buildTextField(
                        label: 'Printer Name',
                        onSaved: (value) => printerName = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a printer name';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        label: 'Print Speed',
                        onSaved: (value) => printSpeed = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter print speed';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        label: 'Active Power',
                        onSaved: (value) => activePower = value,
                      ),
                      _buildTextField(
                        label: 'Idle Power',
                        onSaved: (value) => idlePower = value,
                      ),
                      _buildTextField(
                        label: 'Print Time',
                        onSaved: (value) => printTime = value,
                      ),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: _savePrinter,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                'Save Printer',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 10), // Add spacing between buttons
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PrinterListPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                'View Printer',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {


                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                'Test Algorithm',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ],
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
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  void _savePrinter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await savePrinterData(
          printerName!,
          printSpeed!,
          activePower ?? '0', // Default value if not provided
          idlePower ?? '0',
          printTime ?? '0',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Printer saved successfully!')),
        );

        // Navigate back after successful save
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save printer: $e')),
        );
      }
    }
  }
}
