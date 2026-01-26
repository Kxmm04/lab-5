import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Pageone extends StatefulWidget {
  const Pageone({super.key});

  @override
  State<Pageone> createState() => _PageoneState();
}

class _PageoneState extends State<Pageone> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  String resultText = '';
  Color resultColor = Colors.red;

  Future<void> login() async {
    try {
      final url = Uri.parse(
        'ใส่URL API ตรงนี้เด้อ',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": usernameCtrl.text,
          "password": passwordCtrl.text,
        }),
      );

      print("===== RAW RESPONSE =====");
      print(response.body);

      // ตัด JSON ก้อนแรกออก
      final raw = response.body.trim();
      final secondJsonIndex = raw.indexOf('{', 1);

      if (secondJsonIndex == -1) {
        throw Exception("Invalid JSON format from API");
      }

      final cleanJson = raw.substring(secondJsonIndex);

      print("===== JSON USED =====");
      print(cleanJson);

      final data = jsonDecode(cleanJson);

      if (data['result'] == 1) {
        final user = data['datalist'][0];

        print("===== LOGIN SUCCESS =====");
        print("ชื่อ: ${user['cus_name']}");

        setState(() {
          resultText = "เข้าสู่ระบบสำเร็จ";
          resultColor = Colors.green;
        });
      } else {
        print("===== LOGIN FAIL =====");

        setState(() {
          resultText = "ไม่พบบัญชีผู้ใช้ หรือรหัสผ่านไม่ถูกต้อง";
          resultColor = Colors.red;
        });
      }
    } catch (e) {
      print("===== ERROR =====");
      print(e.toString());

      setState(() {
        resultText = "เกิดข้อผิดพลาดในการเชื่อมต่อ";
        resultColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              const Text(
                "LOGIN",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: usernameCtrl,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                child: const Text("LOGIN"),
              ),
              const SizedBox(height: 20),
              Text(
                resultText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: resultColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
