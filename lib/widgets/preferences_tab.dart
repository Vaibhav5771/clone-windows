import 'package:flutter/material.dart';
import 'package:chats_windows/colors.dart';

import '../info.dart';

class PreferencesTab extends StatelessWidget {
  const PreferencesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.077,
      width: MediaQuery.of(context).size.width * 0.25,
      padding: const EdgeInsets.all(5),
      color: webAppBarColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Center(
                // Center the text horizontally
                child: Text(
                  'Preferences',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.015, // Adjust font size based on screen width
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center, // Ensures text aligns properly in smaller screens
                ),
              ),
            ],
          )

        ],

      ),
    );
  }
}

class PreferencesPanel extends StatefulWidget {
  @override
  _PreferencesPanelState createState() => _PreferencesPanelState();
}

class _PreferencesPanelState extends State<PreferencesPanel> {
  // State variables
  int _copiesGroupValue = 1; // Selected value for No. of Copies
  bool _isColor = true; // Switch state for Color Scheme
  int _paperSizeGroupValue = 1; // Selected value for Paper Size
  int _sidesGroupValue = 1; // Selected value for Sides
  // Variable for selected printer
  String? _selectedPrinter;
  TextEditingController _customCopiesController = TextEditingController();


  // List of available printer options
  final List<String> _printerOptions = [
    'Printer 1',
    'Printer 2',
    'Printer 3',
    'Printer 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.25,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // No. of Copies
              buildCopiesField(),
              Divider(color: Colors.grey),

              // Color Scheme
              buildColorSchemeField(),
              Divider(color: Colors.grey),

              // Paper Size
              buildPaperSizeField(),
              Divider(color: Colors.grey),

              // Sides
              buildSidesField(),
              Divider(color: Colors.grey),

              buildPageRangeField(),
              Divider(
                  color: Colors.grey),

              buildAllocatedPrinterField(),
              Divider(
                  color: Colors.grey),


              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [buildCancelButton(context),
                    buildPrintButton(context),
                  ]
              ),

              // Additional Custom Option
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCopiesField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "No. of Copies",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Radio button for 1 copy
              Radio<int>(
                value: 1,
                groupValue: _copiesGroupValue,
                onChanged: (value) {
                  setState(() {
                    _copiesGroupValue = value!;
                    _customCopiesController
                        .clear(); // Clear custom field when a radio button is selected
                  });
                },
                activeColor: Colors.black,
              ),
              Text("1", style: TextStyle(color: Colors.black, fontSize: 18)),

              // Radio button for 2 copies
              Radio<int>(
                value: 2,
                groupValue: _copiesGroupValue,
                onChanged: (value) {
                  setState(() {
                    _copiesGroupValue = value!;
                    _customCopiesController
                        .clear(); // Clear custom field when a radio button is selected
                  });
                },
              ),
              Text("2", style: TextStyle(color: Colors.black, fontSize: 18)),

              // TextField for custom number of copies
              Container(
                width: 80,
                child: TextField(
                  controller: _customCopiesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Custom',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),// Rectangular border
                      borderRadius: BorderRadius.circular(
                          12), // No rounded corners
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10,
                        vertical: 10), // Optional padding for the text
                  ),
                  onChanged: (value) {
                    setState(() {
                      _copiesGroupValue = int.tryParse(value) ??
                          _copiesGroupValue; // Update the group value with custom number if valid
                    });
                  },
                ),
              ),

            ],
          ),
        ],
      ),
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
                value: _isColor,
                onChanged: (value) {
                  setState(() {
                    _isColor = value;
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

  Widget buildPaperSizeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Paper Size",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10), // Adds spacing between the title and options
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20, // Horizontal spacing between radio buttons and labels
              runSpacing: 10, // Vertical spacing for wrapping
              children: [
                buildRadioOption1("A4", 1),
                buildRadioOption1("A3", 2),
                buildRadioOption1("Legal", 3),
                buildRadioOption1("Letter", 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSidesField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Sides",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10), // Adds spacing between the title and options
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20, // Horizontal spacing between radio buttons and labels
              runSpacing: 10, // Vertical spacing for wrapping
              children: [
                buildRadioOption("Front", 1),
                buildRadioOption("Both", 2),
                buildRadioOption("Even", 3),
                buildRadioOption("Odd", 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRadioOption1(String label, int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: _paperSizeGroupValue,
          onChanged: (value) {
            setState(() {
              _paperSizeGroupValue = value!;
            });
          },
          activeColor: Colors.black,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ],
    );
  }

  Widget buildRadioOption(String label, int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: _sidesGroupValue,
          onChanged: (value) {
            setState(() {
              _sidesGroupValue = value!;
            });
          },
          activeColor: Colors.black,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ],
    );
  }


  Widget buildPageRangeField() {
    final TextEditingController fromController = TextEditingController();
    final TextEditingController toController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Select Pages",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // "From" TextField
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      // Reduced padding for smaller box
                      child: TextField(
                        controller: fromController,
                        decoration: InputDecoration(
                          hintText: "Start",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Rounded corners
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            // Reduced horizontal padding for smaller box
                            vertical: 8.0, // Reduced vertical padding for smaller box
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16.0, // Adjust font size if needed
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5), // Spacing between fields
              // "To" TextField
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      // Reduced padding for smaller box
                      child: TextField(
                        controller: toController,
                        decoration: InputDecoration(
                          hintText: "End",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Rounded corners
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            // Reduced horizontal padding for smaller box
                            vertical: 8.0, // Reduced vertical padding for smaller box
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16.0, // Adjust font size if needed
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
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
                // Background color
                borderRadius: BorderRadius.circular(6.0),
                // Smaller rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // Subtle shadow
                    blurRadius: 5.0, // Shadow spread
                    offset: Offset(0, 2), // Shadow direction
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5.0, vertical: 0.0),
                // Reduced padding for smaller dropdown
                child: DropdownButton<String>(
                  value: _selectedPrinter,
                  hint: Text(
                    'Select Printer',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPrinter = newValue;
                    });
                  },
                  underline: SizedBox(),
                  // Removes the underline
                  isExpanded: true,
                  // Makes the dropdown take full width
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  items: _printerOptions.map((printer) {
                    return DropdownMenuItem<String>(
                      value: printer,
                      child: Text(
                        printer,
                        style: TextStyle(
                          fontSize: 12.0, // Smaller font size for dropdown text
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


  // Cancel Button Widget
  // Cancel Button Widget
  Widget buildCancelButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery
            .of(context)
            .size
            .height * 0.01, // Responsive vertical padding
      ),
      child: ElevatedButton(
        onPressed: () {
          // Handle cancel action here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey, // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery
                .of(context)
                .size
                .height * 0.02, // Vertical padding
            horizontal: MediaQuery
                .of(context)
                .size
                .width * 0.03, // Horizontal padding
          ),
        ),
        child: Text(
          "Cancel",
          style: TextStyle(
            fontSize: MediaQuery
                .of(context)
                .size
                .width * 0.012, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.black, // Text color
          ),
        ),
      ),
    );
  }

// Print Button Widget
  Widget buildPrintButton(BuildContext context) {

      return ElevatedButton(
        onPressed: () {
          // Handle print action here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery
                .of(context)
                .size
                .height * 0.02, // Vertical padding
            horizontal: MediaQuery
                .of(context)
                .size
                .width * 0.04, // Horizontal padding
          ),
        ),
        child: Text(
          "Print",
          style: TextStyle(
            fontSize: MediaQuery
                .of(context)
                .size
                .width * 0.012, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color
          ),
        ),
      );
  }
}