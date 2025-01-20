import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:looting/Screen/home_screen.dart';
import 'package:looting/Screen/signup_screen.dart';

import '../model/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  Users users = Users();

  // ฟังก์ชันสำหรับการรีเซ็ตรหัสผ่าน
  Future<void> _resetPassword() async {
    String email = _emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกอีเมลก่อน')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('อีเมลสำหรับรีเซ็ตรหัสผ่านถูกส่งไปยังอีเมลของคุณ')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Error"),
            ),
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              backgroundColor: Color(0xFFFFC107),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Form(
                      key: formkey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 150,
                              backgroundImage:
                              AssetImage('assets/images/logo3.jpg'),
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "ลงชื่อเข้าใช้งาน",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                            // ช่องกรอกอีเมล
                            TextFormField(
                              controller: _emailController,
                              validator: MultiValidator([
                                RequiredValidator(errorText: "กรุณาป้อนอีเมล"),
                                EmailValidator(
                                    errorText: "รูปแบบของอีเมลไม่ถูกต้อง")
                              ]),
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
                            ),
                            SizedBox(height: 16),

                            // ช่องกรอกรหัสผ่าน
                            TextFormField(
                              controller: _passwordController,
                              validator: RequiredValidator(
                                  errorText: "กรุณาป้อนรหัสผ่าน"),
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
                            ),
                            SizedBox(height: 20),
                            // ปุ่มเข้าสู่ระบบ
                            ElevatedButton(
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  String email = _emailController.text;
                                  String password = _passwordController.text;

                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                        email: email, password: password)
                                        .then((value) {
                                      formkey.currentState?.reset();
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                            return HomeScreen();
                                          }));
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'เกิดข้อผิดพลาด: ${e.message}')));
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF000000),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text(
                                'เข้าสู่ระบบ',
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
                                      return SignUpScreen();
                                    }));
                              },
                              child: Text(
                                'ยังไม่มีบัญชี กดที่นี่',
                                style: TextStyle(
                                    color: Color(0xFF000000), fontSize: 15),
                              ),
                            ),
                            // ลิงค์สำหรับรีเซ็ตรหัสผ่าน
                            TextButton(
                              onPressed: _resetPassword,
                              child: Text(
                                'ลืมรหัสผ่าน? คลิกที่นี่',
                                style: TextStyle(
                                    color: Color(0xFF000000), fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ));
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
