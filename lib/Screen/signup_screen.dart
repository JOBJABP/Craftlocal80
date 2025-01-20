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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  Users users = Users();
  CollectionReference _userCollection = FirebaseFirestore.instance.collection("users");

  void _signUp() async {
    if (formkey.currentState!.validate()) {
      // ดึงค่าจาก TextEditingController
      String fname = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        // สร้างผู้ใช้ใน Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // เพิ่มข้อมูลผู้ใช้ใน Firestore
        await _userCollection.doc(userCredential.user!.uid).set({
          "uid": userCredential.user!.uid,
          "fname": fname,
          "email": email,
          // "phone": "เบอร์โทรศัพท์",
          // "address": "ที่อยู่",
          // "createdAt": FieldValue.serverTimestamp(),
        });

        print("สร้างบัญชีสำเร็จ!");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('เกิดข้อผิดพลาด: ${e.message}'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง')));
    }
  }

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
            return Scaffold(
              backgroundColor: Color(0xFFFFC107),
              appBar: AppBar(
                title: Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          backgroundImage: AssetImage('assets/images/logo3.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(height: 20),
                        Text("สมัครสมาชิก", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: _nameController,  // ใช้ _nameController ที่นี่
                          validator: RequiredValidator(errorText: "กรุณาป้อนชื่อผู้ใช้"),
                          decoration: InputDecoration(
                            labelText: 'กรุณากรอกชื่อ',
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
                            prefixIcon: Icon(Icons.person),
                            filled: true,
                            fillColor: Color(0xFFFDEAB2),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController, // ใช้ _emailController ที่นี่
                          validator: MultiValidator([RequiredValidator(errorText: "กรุณาป้อนอีเมล"), EmailValidator(errorText: "รูปแบบของอีเมลไม่ถูกต้อง")]),
                          decoration: InputDecoration(
                            labelText: 'กรุณากรอก Email',
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
                            prefixIcon: Icon(Icons.email),
                            filled: true,
                            fillColor: Color(0xFFFDEAB2),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,  // ใช้ _passwordController ที่นี่
                          validator: RequiredValidator(errorText: "กรุณาป้อนรหัสผ่าน"),
                          decoration: InputDecoration(
                            labelText: 'กรุณากรอกรหัสผ่าน',
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
                            prefixIcon: Icon(Icons.lock),
                            filled: true,
                            fillColor: Color(0xFFFDEAB2),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF000000),
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text('สมัคร', style: TextStyle(color: Color(0xFFFFC107), fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 5),
                        TextButton(
                          onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())); },
                          child: Text('มีบัญชีแล้วกด ที่นี่', style: TextStyle(color: Color(0xFF000000), fontSize: 15)),
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
            appBar: AppBar(title: Text("Idle")),
            body: Center(child: Text("Awaiting connection")),
          );
        }
      },
    );
  }
}
