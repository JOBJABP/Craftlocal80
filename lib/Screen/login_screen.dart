import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:looting/Screen/home_screen.dart';

import '../model/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  Users users = Users();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase, // Future ที่เรียกใช้งาน
      builder: (context, snapshot) {
        // ตรวจสอบกรณีที่เกิดข้อผิดพลาด
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
                            SizedBox(height: 20),
                            // ปุ่มสมัคร
                            ElevatedButton(
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  formkey.currentState?.save();
                                  // print("name = ${user.name} email = ${user.email} password = ${user.password} confirm= ${user.confirm} ");
                                  // formkey.currentState?.reset();
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: users.email!,
                                            password: users.password!)
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
                                Navigator.pushReplacementNamed(
                                    context, '/signup');
                              },
                              child: Text(
                                'ยังไม่มีบัญชี กดที่นี่',
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
  // final _usernameController = TextEditingController();
  // final _passwordController = TextEditingController();
  //
  // void _login() {
  //   String username = _usernameController.text;
  //   String password = _passwordController.text;
  //
  //   if (username.isNotEmpty && password.isNotEmpty) {
  //     Navigator.pushReplacementNamed(context, '/home');
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('กรุณากรอกชื่อผู้ใช้และรหัสผ่าน')),
  //     );
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   _usernameController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     resizeToAvoidBottomInset: true,
  //     backgroundColor: Color(0xFFFFC107),
  //     body: Center(
  //       child: SingleChildScrollView(
  //         padding: const EdgeInsets.all(50.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             // โลโก้
  //             CircleAvatar(
  //               radius: 150,
  //               backgroundImage: AssetImage('assets/images/logo3.jpg'),
  //               backgroundColor: Colors.transparent,
  //             ),
  //             SizedBox(height: 20),
  //             Text(
  //               "ลงชื่อเข้าใช้",
  //               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(height: 30),
  //
  //             // ช่องกรอกชื่อผู้ใช้
  //             TextField(
  //               controller: _usernameController,
  //               decoration: InputDecoration(
  //                 labelText: 'ชื่อผู้ใช้',
  //                 border: OutlineInputBorder(
  //                   borderSide: BorderSide.none,
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 prefixIcon: Icon(Icons.person),
  //                 filled: true,
  //                 fillColor: Color(0xFFFDEAB2),
  //               ),
  //             ),
  //             SizedBox(height: 20),
  //             // ช่องกรอกรหัสผ่าน
  //             TextField(
  //               controller: _passwordController,
  //               decoration: InputDecoration(
  //                 labelText: 'รหัสผ่าน',
  //                 border: OutlineInputBorder(
  //                   borderSide: BorderSide.none,
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 prefixIcon: Icon(Icons.lock),
  //                 filled: true,
  //                 fillColor: Color(0xFFFDEAB2),
  //               ),
  //               obscureText: true,
  //             ),
  //             SizedBox(height: 20),
  //             // ปุ่มล็อกอิน
  //             ElevatedButton(
  //               onPressed: _login,
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.black,
  //                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //               ),
  //               child: Text(
  //                 'ลงชื่อ',
  //                 style: TextStyle(
  //                     color: Color(0xFFFDBF07),
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             SizedBox(height: 5),
  //
  //             // ลิงค์ไปหน้าสมัครสมาชิก
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, '/signup');
  //               },
  //               child: Text(
  //                 'ไม่มีบัญชี? กดที่นี่',
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
