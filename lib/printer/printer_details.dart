import 'package:flutter/material.dart';

class PrinterDetailsPage extends StatelessWidget {
  final Map<String, dynamic> printer; // Accept the printer data as a parameter

  PrinterDetailsPage({required this.printer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Details'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Printer Name
            Card(
              elevation: 5,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Printer Name',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    Text(
                      '${printer['name']}',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // Print Speed
            Card(
              elevation: 5,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.speed, color: Colors.blueAccent),
                    SizedBox(width: 10),
                    Text(
                      'Speed: ${printer['printSpeed']} ppm',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

            // Active Power
            Card(
              elevation: 5,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.power, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Text(
                      'Active Power: ${printer['activePower']} W',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

            // Idle Power
            Card(
              elevation: 5,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.battery_unknown, color: Colors.greenAccent),
                    SizedBox(width: 10),
                    Text(
                      'Idle Power: ${printer['idlePower']} W',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

            // Print Time
            Card(
              elevation: 5,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: Colors.orangeAccent),
                    SizedBox(width: 10),
                    Text(
                      'Print Time: ${printer['printTime']} min',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

            // Start Printing Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle print action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
