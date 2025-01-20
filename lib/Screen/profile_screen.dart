import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลผู้ใช้งานที่กำลังล็อกอิน
    User? user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('โปรไฟล์'),
          backgroundColor: Color(0xFFFFC107),
        ),
        body: Center(
          child: Text('No user logged in.'),
        ),
      );
    }

    // ดึงข้อมูลจาก Firestore
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('โปรไฟล์'),
              backgroundColor: Color(0xFFFFC107),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: Text('โปรไฟล์'),
              backgroundColor: Color(0xFFFFC107),
            ),
            body: Center(child: Text('No user data found.')),
          );
        }

        // ดึงข้อมูลจาก Firestore
        var userData = snapshot.data!;
        String fname = userData['fname'] ?? 'First Name';
        // String job = userData['job'] ?? 'Job Title';

        return Scaffold(
          appBar: AppBar(
            title: Text('โปรไฟล์'),
            backgroundColor: Color(0xFFFFC107),
          ),
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/satoshi.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$fname',  // แสดงชื่อผู้ใช้งาน
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        // Text(
                        //   job,  // แสดงอาชีพ
                        //   style: TextStyle(
                        //     fontSize: 18.0,
                        //     fontWeight: FontWeight.w300,
                        //     color: Colors.black,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}