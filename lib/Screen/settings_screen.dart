import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  // ฟังก์ชันแสดง Dialog เปลี่ยนชื่อ
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
              onPressed: () async {
                String newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  try {
                    // อัปเดตชื่อใน Firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .update({'fname': newName});

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('เปลี่ยนชื่อสำเร็จ!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('เกิดข้อผิดพลาดในการเปลี่ยนชื่อ')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('กรุณากรอกชื่อใหม่')),
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
  // ฟังก์ชันแสดง Dialog เปลี่ยนรหัสผ่าน
  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController _currentPasswordController = TextEditingController();
    final TextEditingController _newPasswordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text('เปลี่ยนรหัสผ่าน', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่านปัจจุบัน',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่านใหม่',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'ยืนยันรหัสผ่านใหม่',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
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
              onPressed: () async {
                String currentPassword = _currentPasswordController.text.trim();
                String newPassword = _newPasswordController.text.trim();
                String confirmPassword = _confirmPasswordController.text.trim();

                if (newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
                  if (newPassword == confirmPassword) {
                    try {
                      // ตรวจสอบรหัสผ่านปัจจุบัน (ต้องใช้ฟังก์ชัน reauthenticate)
                      final credential = EmailAuthProvider.credential(
                        email: user!.email!,
                        password: currentPassword,
                      );
                      await user!.reauthenticateWithCredential(credential);

                      // เปลี่ยนรหัสผ่าน
                      await user!.updatePassword(newPassword);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('เปลี่ยนรหัสผ่านสำเร็จ!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('รหัสผ่านใหม่ไม่ตรงกัน')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('กรุณากรอกรหัสผ่านใหม่')),
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
                        'รายละเอียดผู้ใช้งาน',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ชื่อ: ${userData['fname']}',
                                    style: TextStyle(fontSize: 15)),
                                Text('อีเมล: ${user!.email}',
                                    style: TextStyle(fontSize: 15)),
                                userData['phone'] != null
                                    ? Text('เบอร์โทร: ${userData['phone']}',
                                    style: TextStyle(fontSize: 15))
                                    : SizedBox(), // แสดงเบอร์โทรหากมีข้อมูล
                              ],
                            );
                          } else {
                            return Text("ไม่มีข้อมูลผู้ใช้");
                          }
                        },
                      )
                          : Text("ยังไม่มีผู้ใช้ล็อกอิน"),
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
              leading: Icon(Icons.lock),
              title: Text('เปลี่ยนรหัสผ่าน'),
              onTap: () {
                _showChangePasswordDialog(context); // แสดง Dialog เปลี่ยนรหัสผ่าน
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
