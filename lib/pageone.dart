import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Pageone extends StatefulWidget {
  const Pageone({super.key});

  @override
  State<Pageone> createState() => _PageoneState();
}

class _PageoneState extends State<Pageone> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool hidePassword = true;

  String resultText = '';
  Color resultColor = Colors.red;

  Future<void> login() async {
    print("===== LOGIN START =====");

    try {
      final url = Uri.parse(
        'http://172.24.149.141/bis3n2_2/mobile_service_68/login.php',
      );

      print("URL: $url");
      print("USERNAME: ${usernameCtrl.text}");
      print("PASSWORD: ${passwordCtrl.text}");

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

      // API ส่ง JSON 2 ก้อน → เอาก้อนหลัง
      final raw = response.body.trim();
      final index = raw.indexOf('{', 1);

      if (index == -1) {
        throw "รูปแบบ JSON ไม่ถูกต้อง";
      }

      final cleanJson = raw.substring(index);

      print("===== CLEAN JSON =====");
      print(cleanJson);

      final data = jsonDecode(cleanJson);

      print("===== RESULT =====");
      print(data);

      if (data['result'] == 1) {
  final user = data['datalist'][0];

  print("===== LOGIN SUCCESS =====");
  print("cus_id       : ${user['cus_id']}");
  print("cus_name     : ${user['cus_name']}");
  print("cus_username : ${user['cus_username']}");

  setState(() {
    resultText = "เข้าสู่ระบบสำเร็จ";
    resultColor = Colors.green;
  });
} else {
  print("===== LOGIN FAIL =====");
  print("ไม่พบบัญชีผู้ใช้");

  setState(() {
    resultText = "ไม่พบบัญชีผู้ใช้ หรือรหัสผ่านไม่ถูกต้อง";
    resultColor = Colors.red;
  });
}

    } catch (e) {
       print("===== CONNECTION ERROR =====");
       print(e);

      setState(() {
        resultText = "เกิดข้อผิดพลาดในการเชื่อมต่อ";
        resultColor = Colors.red;
      });
    }

    print("===== LOGIN END =====");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 30),

                /// LOGO
                const Icon(
                  Icons.autorenew_rounded,
                  size: 80,
                  color: Color(0xFF2F6FED),
                ),
                const SizedBox(height: 10),
                const Text(
                  "OrbitFlow",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                /// USERNAME
                TextField(
                  controller: usernameCtrl,
                  decoration: InputDecoration(
                    hintText: "Username or Email",
                    prefixIcon: const Icon(Icons.person_outline),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// PASSWORD
                TextField(
                  controller: passwordCtrl,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F6FED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// RESULT
                Text(
                  resultText,
                  style: TextStyle(
                    color: resultColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
