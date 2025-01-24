import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../printer/print_job_service.dart';
import '../printer/printer_allocation.dart';
import '../printer/save_printer.dart';

class EditablePreferencesScreen extends StatefulWidget {
  final Map<String, dynamic> preferencesData;
  final String fileUrl;

  EditablePreferencesScreen({
    Key? key,
    required this.preferencesData,
    required this.fileUrl
  }) : super(key: key);

  @override
  _EditablePreferencesScreenState createState() => _EditablePreferencesScreenState();
}

class _EditablePreferencesScreenState extends State<EditablePreferencesScreen> {
  late TextEditingController startPageController;
  late TextEditingController endPageController;
  late TextEditingController copiesController;
  bool isColor = false;
  int selectedPaperSize = 1;
  int selectedSides = 1;

  String? _selectedPrinter;  // Variable to hold the selected printer
  List<String> _printerOptions = []; // List of printers


  @override
  void initState() {
    super.initState();
    updateControllers();
    _fetchPrinterList();
  }

  // Inside your current page (where the UI is handled)

  void _processPrintJob() {
    int startPage = int.parse(startPageController.text);
    int endPage = int.parse(endPageController.text);
    int copies = int.parse(copiesController.text);

    bool colorScheme = isColor;
    String paperSize = ["A4", "A3", "Legal", "Letter"][selectedPaperSize - 1];
    String sides = ["Front Only", "Both Sides", "Even Sides", "Odd Sides"][selectedSides - 1];
    String printer = _selectedPrinter ?? "Default Printer";

    // Call the PrintJobService's static method to process the job
    PrintJobService.processPrintJob(
      startPage: startPage,
      endPage: endPage,
      copies: copies,
      isColor: colorScheme,
      selectedPaperSize: selectedPaperSize,
      selectedSides: selectedSides,
      printerOptions: _printerOptions,
      fileUrl: widget.fileUrl,
      context: context,
    );
  }





  // Method to fetch printer list from Firestore
  void _fetchPrinterList() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid; // Ensure user is authenticated
      DocumentReference userDoc = FirebaseFirestore.instance.collection('Users').doc(userId);

      // Reference to the subcollection "printerList"
      CollectionReference printerList = userDoc.collection('printerList');

      // Fetch the data
      QuerySnapshot snapshot = await printerList.get();

      // Convert the data into a list of maps
      List<Map<String, dynamic>> printers = snapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include the document ID if needed
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      setState(() {
        _printerOptions = printers.map((printer) => printer['name'] as String).toList();
        if (_printerOptions.isNotEmpty) {
          _selectedPrinter = _printerOptions[0]; // Default selection
        }
      });

    } catch (e) {
      print("Error fetching printer list: $e");
      // Handle error here, show message to user
    }
  }



  @override
  void didUpdateWidget(covariant EditablePreferencesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.preferencesData != oldWidget.preferencesData) {
      updateControllers();
    }
  }

  void updateControllers() {
    startPageController = TextEditingController(text: widget.preferencesData['startPage'].toString());
    endPageController = TextEditingController(text: widget.preferencesData['endPage'].toString());
    copiesController = TextEditingController(text: widget.preferencesData['copies'].toString());
    isColor = widget.preferencesData['isColor'];
    selectedPaperSize = widget.preferencesData['paperSize'];
    selectedSides = widget.preferencesData['sides'];
    setState(() {});
  }

  void _launchFileUrl() async {
    if (await canLaunch(widget.fileUrl)) {
      await launch(widget.fileUrl);
    } else {
      throw 'Could not launch ${widget.fileUrl}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Preferences'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavePrinterPage()),
              );
            },
            child: Icon(
              Icons.add,  // Icon you want to display (e.g., '+' sign)
              size: 30.0,  // Adjust the size
              color: Colors.white, // Color of the icon
            ),
          ),
          SizedBox(width: 10),  // Optional: Add space between icons
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Start and End Page in One Row
            buildTextField("No. of Copies", copiesController),
            Divider(
              color: Colors.black, // Divider color
              thickness: 0.2, // Thin divider
              indent: 5, // Optional: adds space from the left side
              endIndent: 5, // Optional: adds space from the right side
            ),
            Row(
              children: [
                Expanded(child: buildTextField("Start Page", startPageController)),
                SizedBox(width: 10),
                Expanded(child: buildTextField("End Page", endPageController)),
              ],
            ),
            Divider(
              color: Colors.black, // Divider color
              thickness: 0.2, // Thin divider
              indent: 5, // Optional: adds space from the left side
              endIndent: 5, // Optional: adds space from the right side
            ),
            buildColorSchemeField(),
            Divider(
              color: Colors.black, // Divider color
              thickness: 0.2, // Thin divider
              indent: 5, // Optional: adds space from the left side
              endIndent: 5, // Optional: adds space from the right side
            ),// Updated Color Scheme using Switch
            buildRadioButton("Paper Size", ["A4", "A3", "Legal", "Letter"], selectedPaperSize - 1,
                    (value) => setState(() => selectedPaperSize = value + 1)),
            Divider(
              color: Colors.black, // Divider color
              thickness: 0.2, // Thin divider
              indent: 5, // Optional: adds space from the left side
              endIndent: 5, // Optional: adds space from the right side
            ),
            buildRadioButton("Sides", ["Front Only", "Both Sides", "Even Sides", "Odd Sides"], selectedSides - 1,
                    (value) => setState(() => selectedSides = value + 1)),
            Divider(
              color: Colors.black, // Divider color
              thickness: 0.2, // Thin divider
              indent: 5, // Optional: adds space from the left side
              endIndent: 5, // Optional: adds space from the right side
            ),
            buildAllocatedPrinterField(),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "File URL:",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Changed text color to black
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: _launchFileUrl,
                    child: Text(
                      widget.fileUrl,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black, // Changed text color to black
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Divider(
              color: Colors.black, // Divider color
              thickness: 0.2, // Thin divider
              indent: 5, // Optional: adds space from the left side
              endIndent: 5, // Optional: adds space from the right side
            ),
            const SizedBox(height: 5),
            // Reset and Print buttons at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.white), // Text color
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Circular button
                        ),
                        backgroundColor: Colors.black, // Button color
                        // Text color (already set)
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _processPrintJob(); // Process the print job when clicked
                      },
                      child: Text(
                        'Print',
                        style: TextStyle(color: Colors.white), // Text color
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Circular button
                        ),
                        backgroundColor: Colors.blue, // Button color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.black,
        ),
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Updated label style
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Focus border color set to black
          ),
        ),
      ),
    );
  }

  Widget buildRadioButton(String label, List<String> options, int selectedValue, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)), // Changed text color to black
        Column(
          children: List.generate(options.length, (index) {
            return RadioListTile(
              title: Text(options[index], style: TextStyle(color: Colors.black)), // Changed text color to black
              value: index,
              groupValue: selectedValue,
              onChanged: (value) => onChanged(value!),
              activeColor: Colors.black,
            );
          }),
        )
      ],
    );
  }

  Widget buildColorSchemeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Center(
            child: Text(
              "Color Scheme",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("B & W",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              Switch(
                value: isColor,
                onChanged: (value) {
                  setState(() {
                    isColor = value;
                  });
                },
                activeColor: Colors.black,
                inactiveThumbColor: Colors.grey,
              ),
              Text("Color",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAllocatedPrinterField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Allocated Printer",
            style: TextStyle(
              fontSize: 18, // Smaller title font size
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5), // Adjusted spacing
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // Subtle shadow
                    blurRadius: 5.0, // Shadow spread
                    offset: Offset(0, 2), // Shadow direction
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: _printerOptions.isEmpty
                    ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
                    : DropdownButton<String>(
                  value: _selectedPrinter,
                  hint: Text(
                    'Select Printer',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPrinter = newValue;
                    });
                  },
                  underline: SizedBox(),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  items: _printerOptions.map((printer) {
                    return DropdownMenuItem<String>(
                      value: printer,
                      child: Text(
                        printer,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}