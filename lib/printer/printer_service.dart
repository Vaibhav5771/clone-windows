import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> savePrinterData(String name, String speed, String activePower,
    String idlePower, String printTime) async {
  try {
    String userId =
        FirebaseAuth.instance.currentUser!.uid; // Ensure user is authenticated
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('Users').doc(userId);

    // Use a subcollection "printerList" under the user's document
    CollectionReference printerList = userDoc.collection('printerList');

    await printerList.add({
      'name': name,
      'printSpeed': speed,
      'activePower': activePower,
      'idlePower': idlePower,
      'printTime': printTime,
    });

    print('Printer data saved successfully!');
  } catch (error) {
    print('Failed to save printer: $error');
  }
}

Future<List<Map<String, dynamic>>> getPrinterData() async {
  try {
    String userId =
        FirebaseAuth.instance.currentUser!.uid; // Ensure user is authenticated
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('Users').doc(userId);

    // Reference to the subcollection "printerList"
    CollectionReference printerList = userDoc.collection('printerList');

    // Retrieve the data
    QuerySnapshot snapshot = await printerList.get();

    // Convert data into a list of maps
    List<Map<String, dynamic>> printers = snapshot.docs.map((doc) {
      return {
        'id': doc.id, // Include the document ID if needed
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();

    return printers;
  } catch (error) {
    print('Failed to retrieve printer data: $error');
    return [];
  }
}
