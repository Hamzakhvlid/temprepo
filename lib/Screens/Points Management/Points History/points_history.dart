import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PointsDetails extends StatefulWidget {
  @override
  _PointsDetailsState createState() => _PointsDetailsState();
}

class _PointsDetailsState extends State<PointsDetails> {
  bool containsNumbers(String text) {
    return RegExp(r'\d').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Points Details'),
          bottom: TabBar(
            tabs: [
              Tab(
                  text: 'Pending',
                  icon: Icon(Icons.access_time, color: Colors.redAccent)),
              Tab(
                text: 'Completed',
                icon: Icon(Icons.check, color: Colors.green),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPendingContent(false),
            _buildPendingContent(true),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingContent(bool showCompleted) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('receipts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final receipts = snapshot.data!.docs;

          if (receipts.isEmpty) {
            return Center(
              child: Text('You have no history'),
            );
          }

          final filteredReceipts = receipts.where((receipt) {
            final points = receipt['points'];
            return (showCompleted && containsNumbers(points)) ||
                (!showCompleted && !containsNumbers(points));
          }).toList();

          return ListView.builder(
            itemCount: filteredReceipts.length,
            itemBuilder: (context, index) {
              final receipt = filteredReceipts[index];
              final amount = receipt['amount'];
              final barcode = receipt['barcode'];
              final timestamp = receipt['timestamp'];
              final points = receipt['points'];

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Amount: ',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                '\$${amount.toString()}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Text(
                                'Barcode: ',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                ' $barcode',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Date: ${_formatTimestamp(timestamp)}',
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                      Text(
                        'Points: ${showCompleted ? points != null ? points.toString() : '' : 'Pending'}',
                        style: TextStyle(
                          color: showCompleted
                              ? points != null
                                  ? Colors.green
                                  : Colors.red
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
