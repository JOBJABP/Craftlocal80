import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  bool isDarkModeEnabled = false;
  // สถานะ Dark Mode
  void _showChangeNameDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('เปลี่ยนชื่อ'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'ชื่อใหม่',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิด Dialog
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                String newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  // TODO: อัปเดตชื่อในฐานข้อมูล
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เปลี่ยนชื่อสำเร็จ!')),
                  );
                }
                Navigator.pop(context);
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตั้งค่า'),
        backgroundColor: Color(0xFFFFC107),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ส่วนหัวโปรไฟล์
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              margin: EdgeInsets.all(2),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รายละเอียดผู้ใช้งาน : ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      user != null
                          ? StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text("กำลังโหลด...");
                          } else if (snapshot.hasError) {
                            return Text("เกิดข้อผิดพลาด");
                          } else if (snapshot.hasData && snapshot.data!.exists) {
                            var userData = snapshot.data!.data() as Map<String, dynamic>;
                            return Text(
                              'ชื่อ: ${userData['fname']} ${userData['lname']}',
                              style: TextStyle(fontSize: 15),
                            );
                          } else {
                            return Text("ไม่มีข้อมูลผู้ใช้");
                          }
                        },
                      )
                          : Text("ยังไม่มีผู้ใช้ล็อกอิน"),
                      user != null
                          ? Text('Email: ${user!.email}',style: TextStyle(fontSize: 15),) // แสดงอีเมลผู้ใช้
                          : Text("ยังไม่มีผู้ใช้ล็อกอิน"), // กรณีไม่มีผู้ใช้
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('เปลี่ยนชื่อ'),
              onTap: () {
                _showChangeNameDialog(context); // แสดง Dialog เปลี่ยนชื่อ
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('เปลี่ยนอีเมล'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('เปลี่ยนรหัสผ่าน'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('ลงชื่อออก'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
