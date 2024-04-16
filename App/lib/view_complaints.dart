import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewComplaints extends StatefulWidget {
  const ViewComplaints({Key? key}) : super(key: key);

  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ViewComplaints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pic3.jpg'), // Replace with your background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Centered content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30.0),
                  Text(
                    'My Complaints',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Hobbio3', // Replace with your font family
                      color: Colors.white, // Adjust text color as needed
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ComplaintsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ComplaintsList extends StatelessWidget {
  const ComplaintsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: getUserDoc(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final String? uDoc = snapshot.data?.id;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tbl_complaints')
              .where('user_id', isEqualTo: uDoc)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return ComplaintCard(
                  complaintContent: data['complaint_content'],
                  complaintReply: data['complaint_reply'],
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Future<DocumentSnapshot> getUserDoc() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('tbl_user').where('user_id', isEqualTo: userId).get();
    return userSnapshot.docs.first;
  }
}

class ComplaintCard extends StatelessWidget {
  final String complaintContent;
  final String complaintReply;

  const ComplaintCard({
    required this.complaintContent,
    required this.complaintReply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complaint: $complaintContent',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              complaintReply.isEmpty ? 'Not reviewed by admin' : 'Reply: $complaintReply',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
