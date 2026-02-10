import 'package:flutter/material.dart';
import 'package:lab5/pagetwo.dart';
import 'package:http/http.dart' as http; // รับส่งข้อมูลผ่าน http
import 'dart:async'; // ให้รอการทำงาน
import 'dart:convert';

class Pageone extends StatefulWidget {
  const Pageone({super.key});

  @override
  State<Pageone> createState() => _PageoneState();
}

class _PageoneState extends State<Pageone> {
  final username = TextEditingController();
  final password = TextEditingController();
  String errorText = '';

  bool hidePassword = true;

  // ================= Widget =================

  Widget logoWidget() {
    return Column(
      children: const [
        Icon(Icons.login, size: 80, color: Color(0xFF2F6FED)),
        SizedBox(height: 10),
        Text(
          "Big login",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? hidePassword : false,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          print("on-click");
          Login();
        },

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
    );
  }

  Future<String> Login() async {
    /* print("debug-1410:" + username.text.toString());
    print("debug-1410:" + password.text.toString()); */
    Map<String, String> headers = {
      "content-type": "application/json",
      "accept": "application/json",
    };

    Map<String, String> data_post = {
      "username": username.text.toString(),
      "password": password.text.toString(),
    };

    var uri = Uri.parse(
      "http://172.24.148.197/bis3n2_2/mobile_service_68/login.php",
    );

    var response = await http.post(
      uri,
      headers: headers,
      body: json.encode(data_post),
      encoding: Encoding.getByName("utf-8"),
    );

    Map resp_json = json.decode(response.body);

    print(resp_json);
    print(resp_json['result']);
    if (resp_json['result'] == 1 && resp_json['datalist'] != null) {
      print(resp_json['datalist'][0]['cus_name']);
    } else {
      print("ไม่พบบัญชีผู้ใช้");
    }

    if (resp_json['result'] == 1 && resp_json['datalist'] != null) {
      Map<String, dynamic> user = resp_json['datalist'][0];

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Pagetwo(userData: user)),
      );
    } else {
      setState(() {
        errorText = "ไม่พบบัญชีผู้ใช้ หรือรหัสผ่านไม่ถูกต้อง";
      });
    }

    return "OK";
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              logoWidget(),

              const SizedBox(height: 40),

              inputField(
                controller: username,
                hint: "Username or Email",
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              inputField(
                controller: password,
                hint: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 24),

              loginButton(),

              const SizedBox(height: 20),
              if (errorText.isNotEmpty)
                Text(
                  errorText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
