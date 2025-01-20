import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:looting/Screen/home_screen.dart';
import 'package:looting/model/user.dart';

class Setimage extends StatefulWidget {
  const Setimage({super.key});

  @override
  State<Setimage> createState() => _SetimageState();
}

class _SetimageState extends State<Setimage> {
  final formkey = GlobalKey<FormState>();
  Users myuser = Users();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Loading"),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          } else {
            // ถ้าสำเร็จและไม่มีข้อผิดพลาด
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  'ตั้งค่าโปรไฟล์',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              backgroundColor: Color(0xFFFFC107),
              body: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formkey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ชื่อ',
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator:
                              RequiredValidator(errorText: "กรุณาป้อนชื่อ "),
                          onSaved: (String? fname) {
                            myuser.fname = fname;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'นามสกุล',
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator:
                              RequiredValidator(errorText: "กรุณาป้อนนามสกุล "),
                          onSaved: (String? lname) {
                            myuser.lname = lname;
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  formkey.currentState!.save();
                                  await _userCollection.add({
                                    "fname": myuser.fname,
                                    "lname": myuser.lname
                                  });
                                  formkey.currentState!.reset();
                                  // print("${myuser.fname}");
                                  // print("${myuser.lname}");
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return HomeScreen();
                                  }));
                                }
                              },
                              child: Text(
                                "บันทึกข้อมูล",
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("Idle"),
            ),
            body: Center(
              child: Text("Awaiting connection"),
            ),
          );
        }
      },
    );
  }
}
