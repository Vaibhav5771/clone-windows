import 'package:chats_windows/printer/printer_details.dart';
import 'package:flutter/material.dart';
import '../printer/printer_service.dart';

class PrinterListPage extends StatefulWidget {
  @override
  _PrinterListPageState createState() => _PrinterListPageState();
}

class _PrinterListPageState extends State<PrinterListPage> {
  late Future<List<Map<String, dynamic>>> _printerDataFuture;

  @override
  void initState() {
    super.initState();
    _printerDataFuture = getPrinterData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _printerDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load printers.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No printers found.'));
          } else {
            List<Map<String, dynamic>> printers = snapshot.data!;
            return ListView.builder(
              itemCount: printers.length,
              itemBuilder: (context, index) {
                final printer = printers[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(printer['name']),
                    subtitle: Text('Speed: ${printer['printSpeed']}'),
                    trailing: Icon(Icons.print),
                    onTap: () {
                      // Navigate to PrinterDetailsPage and pass the printer data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrinterDetailsPage(printer: printer),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}