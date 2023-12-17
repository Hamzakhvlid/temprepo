import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EarnPoints extends StatefulWidget {
  @override
  State<EarnPoints> createState() => _EarnPointsState();
}

class _EarnPointsState extends State<EarnPoints> {
  final _barcodeController = TextEditingController();
  final _amountController = TextEditingController();

  File? _pickedFile;
  bool _filePicked = false;
  bool _sendingData = false; //Track for loading indicator of button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earn Points'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.grey[200],
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      const Text(
                        'Fill all the details to get points',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _barcodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter barcode number',
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _amountController,
                        decoration: InputDecoration(
                          hintText: 'Total Amount of receipt',
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: _filePicked
                                    ? Text(_pickedFile!.path
                                        .split('/')
                                        .last) // Show file name
                                    : AutoSizeText(
                                        'Upload receipt',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.attach_file,
                                  color: Colors.redAccent),
                              onPressed: () async {
                                // Implement file attachment logic
                                final pickedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);

                                if (pickedImage != null) {
                                  setState(() {
                                    _pickedFile = File(pickedImage.path!);
                                    _filePicked = true;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          // Implement get points logic
                          await _sendForVerification();
                        },
                        child: _sendingData
                            ? Text('Data is Sending... ')
                            : AutoSizeText(
                                'Send for verification',
                                style: TextStyle(color: Colors.white),
                              ),
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                      ),
                      SizedBox(height: 16.0),
                      AutoSizeText(
                        'You will get points within the next 24 hours after verification',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Divider(color: Colors.black),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // AutoSizeText(
                          //   'Check points conversion table',
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //   ),
                          // ),
                          SizedBox(width: 8.0),
                          InkWell(
                            onTap: () {
                              // Implement link navigation
                            },
                            child: AutoSizeText(
                              'here',
                              style: TextStyle(
                                color: Colors.red,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendForVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Check if any field is empty
        if (_barcodeController.text.isEmpty ||
            _amountController.text.isEmpty ||
            !_filePicked) {
          // Show error toast message
          Fluttertoast.showToast(
            msg: 'Please fill all sections before sending for verification',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return; // Stop execution if any field is empty
        }

        // Upload file to Firebase Storage
        setState(() {
          _sendingData = true;
        });
        String fileName = basenameWithoutExtension(_pickedFile!.path);
        firebase_storage.Reference storageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(fileName);
        firebase_storage.UploadTask uploadTask =
            storageRef.putFile(_pickedFile!);
        firebase_storage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() => null);

        // Get the download URL of the uploaded file
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        // Upload data to Firebase Firestore
        await FirebaseFirestore.instance.collection('receipts').add({
          'uid': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          // Use server timestamp
          'points': '',

          'barcode': _barcodeController.text,
          'amount': _amountController.text,
          'fileURL': downloadURL, // Add the file URL to Firestore
          // Add more fields as needed
        });

        // Display a success message or navigate to a success screen
        print('Data and file uploaded successfully!');

        // Show success toast message
        Fluttertoast.showToast(
          msg: 'Data sent for verification successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Clear the fields
        _barcodeController.clear();
        _amountController.clear();
        setState(() {
          _sendingData = false;
          _filePicked = false;
        });
      } catch (e) {
        print('Error uploading file: $e');
      }
    } else {
      print('User not logged in');
    }
  }
}
