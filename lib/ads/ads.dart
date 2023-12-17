import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadAds extends StatefulWidget {
  @override
  _UploadAdsState createState() => _UploadAdsState();
}

class _UploadAdsState extends State<UploadAds> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CollectionReference _adsCollection =
      FirebaseFirestore.instance.collection('ads');

  List<XFile> _pickedImages = [];
  bool _uploading = false;

  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _pickedImages = pickedImages;
      });
    }
  }

  Future<void> _uploadImagesToFirebase() async {
    setState(() {
      _uploading = true;
    });

    for (final pickedImage in _pickedImages) {
      final imageFile = File(pickedImage.path);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      try {
        // Upload image to Firebase Storage
        final ref = _storage.ref().child('ads/$fileName');
        await ref.putFile(imageFile);

        // Get the download URL of the uploaded image
        final imageUrl = await ref.getDownloadURL();

        // Add image URL to Firestore collection
        await _adsCollection.add({'adsURL': imageUrl});
      } catch (e) {
        print('Error uploading image: $e');
        // Handle the error as needed
      }
    }

    setState(() {
      _pickedImages = [];
      _uploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Images uploaded successfully!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Ads'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: _uploading ? null : _pickImages,
            child: const Text('Pick Ad Images'),
          ),
          const SizedBox(height: 20.0),
          if (_pickedImages.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selected Images:'),
                const SizedBox(height: 10.0),
                Wrap(
                  spacing: 8.0,
                  children: _pickedImages
                      .map((pickedImage) => Chip(
                            label: Text(pickedImage.name),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _uploading ? null : _uploadImagesToFirebase,
                  child: _uploading
                      ? Text('Uploading...')
                      : const Text('Upload Ads'),
                ),
              ],
            ),
          const SizedBox(height: 20.0),
          const Text(
            'Slideable Ads:',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SlideableImageAds(),
        ],
      ),
    );
  }
}

class SlideableImageAds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ads').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final List<String> imageUrls = snapshot.data!.docs
              .map((doc) => doc['adsURL'] as String)
              .toList();

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.38,
            child: CarouselSlider(
              items: imageUrls.asMap().entries.map((entry) {
                final index = entry.key;
                final url = entry.value;

                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Center(
                              child: Image.asset(
                                'assets/logo/logo.png',
                                width: 100,
                                height: 50,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Positioned(
                          top: 5.0,
                          right: 5.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 30,
                            ),
                            color: Colors.red,
                            onPressed: () async {
                              await _deleteImage(index);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.38,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteImage(int index) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('ads').get();
      final docId = snapshot.docs[index].id;
      await FirebaseFirestore.instance.collection('ads').doc(docId).delete();
    } catch (e) {
      print('Error deleting image: $e');
      // Handle the error as needed
    }
  }
}
