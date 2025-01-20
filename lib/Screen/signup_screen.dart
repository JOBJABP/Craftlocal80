import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:looting/Screen/login_screen.dart';
import 'package:looting/model/user.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formkey = GlobalKey<FormState>();
  // final _nameController = TextEditingController();
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  // final _confirmPasswordController = TextEditingController();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  Users users = Users();
  CollectionReference _userCollection =
  FirebaseFirestore.instance.collection("users");

  // void _signUp() {
  //   // String name = _nameController.text;
  //   // String email = _emailController.text;
  //   // String password = _passwordController.text;
  //   // String confirmPassword = _confirmPasswordController.text;
  //
  //   // if (password != confirmPassword) {
  //   //   ScaffoldMessenger.of(context)
  //   //       .showSnackBar(SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')));
  //   //   return;
  //   // }
  //
  //   if (users.email.isNotEmpty && users.password.isNotEmpty) {
  //     Navigator.pushReplacementNamed(context, '/login');
  //   } //else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('กรุณากรอกให้ครบทุกช่อง')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase, // ต้องแน่ใจว่า firebase เป็น Future ที่ถูกต้อง
      builder: (context, snapshot) {
        // ตรวจสอบสถานะการเชื่อมต่อ
        if (snapshot.connectionState == ConnectionState.waiting) {
          // กำลังโหลด
          return Scaffold(
            appBar: AppBar(
              title: Text("Loading"),
            ),
            body: Center(
              child: CircularProgressIndicator(), // แสดงตัวโหลด
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          // โหลดเสร็จแล้ว
          if (snapshot.hasError) {
            // ถ้ามีข้อผิดพลาด
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
                backgroundColor: Color(0xFFFFC107),
                appBar: AppBar(
                  title: Text('Sign Up',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor: Color(0xFFFFC107),
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Form(
                      key: formkey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 120,
                              backgroundImage:
                                  AssetImage('assets/images/logo3.jpg'),
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "สมัครสมาชิก",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),

                            TextFormField(
                              validator: RequiredValidator(
                                  errorText: "กรุณาป้อนชื่อผู้ใช้"),
                              decoration: InputDecoration(
                                labelText: 'กรุณากรอกชื่อ',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(Icons.person),
                                filled: true,
                                fillColor: Color(0xFFFDEAB2),
                              ),
                              onSaved: (String? fname) {
                                if (fname != null && fname.isNotEmpty) {
                                  users.fname = fname;
                                }
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              validator: RequiredValidator(
                                  errorText: "กรุณาป้อนนามสกุล"),
                              decoration: InputDecoration(
                                labelText: 'กรุณากรอกนามสกุล',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(Icons.person),
                                filled: true,
                                fillColor: Color(0xFFFDEAB2),
                              ),
                              onSaved: (String? lname) {
                                if (lname != null && lname.isNotEmpty) {
                                  users.lname = lname;
                                }
                              },
                            ),
                            SizedBox(height: 16),
                            // ช่องกรอกอีเมล
                            TextFormField(
                              validator: MultiValidator([
                                RequiredValidator(errorText: "กรุณาป้อนอีเมล"),
                                EmailValidator(
                                    errorText: "รูปแบบของอีเมลไม่ถูกต้อง")
                              ]),
                              // controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'กรุณากรอก Email',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(Icons.email),
                                filled: true,
                                fillColor: Color(0xFFFDEAB2),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (String? email) {
                                if (email != null && email.isNotEmpty) {
                                  users.email = email;
                                }
                              },
                            ),
                            SizedBox(height: 16),

                            // ช่องกรอกรหัสผ่าน
                            TextFormField(
                              validator: RequiredValidator(
                                  errorText: "กรุณาป้อนรหัสผ่าน"),
                              // controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'กรุณากรอกรหัสผ่าน',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(Icons.lock),
                                filled: true,
                                fillColor: Color(0xFFFDEAB2),
                              ),
                              obscureText: true,
                              onSaved: (String? password) {
                                if (password != null && password.isNotEmpty) {
                                  users.password = password;
                                }
                              },
                            ),
                            SizedBox(height: 16),
                            // ช่องกรอกรหัสผ่านยืนยัน
                            // TextFormField(
                            //   validator: RequiredValidator(
                            //       errorText: "กรุณาป้อนยืนยันรหัสผ่านอีกครั้ง"),
                            //   controller: _confirmPasswordController,
                            //   decoration: InputDecoration(
                            //     labelText: 'ยืนยันรหัสผ่าน',
                            //     border: OutlineInputBorder(
                            //       borderSide: BorderSide.none,
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //     prefixIcon: Icon(Icons.lock),
                            //     filled: true,
                            //     fillColor: Color(0xFFFDEAB2),
                            //   ),
                            //   obscureText: true,
                            //   onSaved: (String? confirm) {
                            //     if (confirm != null && confirm.isNotEmpty) {
                            //       users.confirm = confirm;
                            //     }
                            //   },
                            // ),
                            SizedBox(height: 20),

                            // ปุ่มสมัคร
                            ElevatedButton(
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  formkey.currentState?.save();
                                  // print("name = ${user.name} email = ${user.email} password = ${user.password} confirm= ${user.confirm} ");
                                  // formkey.currentState?.reset();
                                  // try {
                                  //   await FirebaseAuth.instance
                                  //       .createUserWithEmailAndPassword(
                                  //     email: users.email!,
                                  //     password: users.password!,
                                  //
                                  //   )
                                  //       .then((value) {
                                  //     ScaffoldMessenger.of(context)
                                  //         .showSnackBar(SnackBar(
                                  //             content:
                                  //                 Text('สมัครสมาชิกสำเร็จ!')));
                                  //     formkey.currentState?.reset();
                                  //     Navigator.pushReplacement(context,
                                  //         MaterialPageRoute(builder: (context) {
                                  //       return LoginScreen();
                                  //     }));
                                  //   });
                                  //   // Navigator.pushReplacementNamed(context, '/login');
                                  // }
                                  try {
                                    // สร้างผู้ใช้ใน Firebase Authentication
                                    UserCredential userCredential = await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: users.email!,
                                      password: users.password!,
                                    );

                                    // เพิ่มข้อมูลผู้ใช้ใน Firestore
                                    await _userCollection.add({
                                      "uid": userCredential.user!.uid, // บันทึก UID ผู้ใช้
                                      "fname": users.fname,
                                      "lname": users.lname,
                                    });

                                    // แจ้งเตือนหรือทำสิ่งที่ต้องการหลังจากสำเร็จ
                                    print("สร้างบัญชีสำเร็จ!");
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                          return LoginScreen();
                                        }));
                                  } on FirebaseAuthException catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'เกิดข้อผิดพลาด: ${e.message}')));
                                  }
                                }
                              },
                              // onPressed: _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF000000),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text(
                                'สมัคร',
                                style: TextStyle(
                                    color: Color(0xFFFFC107),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),

                            // ลิงค์สำหรับหน้าล็อกอิน
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                }));
                              },
                              child: Text(
                                'มีบัญชีแล้วกด ที่นี่',
                                style: TextStyle(
                                    color: Color(0xFF000000), fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      )),
                ));
          }
        } else {
          // สถานะอื่น ๆ เช่น ConnectionState.none
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
