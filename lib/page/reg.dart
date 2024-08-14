import 'dart:developer' as dev;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/config.dart';
import 'package:flutter_application_3/models/request/CustomersRegPostReq.dart';
import 'package:flutter_application_3/models/response/CustomersLoginPostRes.dart';
import 'package:flutter_application_3/page/login.dart';
import 'package:flutter_application_3/page/show.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String url = '';
  TextEditingController nameNoCtl = TextEditingController();
  TextEditingController emailNoCtl = TextEditingController();
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passNoCtl = TextEditingController();
  TextEditingController confpassNoCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      setState(() {
        url = config['apiEndpoint'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนสมาชิกใหม่'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildTextField('ชื่อ-นามสกุล', nameNoCtl),
              _buildTextField('อีเมลล์', emailNoCtl),
              _buildTextField('หมายเลขโทรศัพท์', phoneNoCtl,
                  keyboardType: TextInputType.phone),
              _buildTextField('รหัสผ่าน', passNoCtl, obscureText: true),
              _buildTextField('ยืนยันรหัสผ่าน', confpassNoCtl,
                  obscureText: true),
              const SizedBox(height: 20),
              FilledButton(onPressed: reg, child: const Text('สมัครสมาชิก')),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {}, // Implement if needed
                    child: const Text('หากมีบัญชีอยู่แล้ว?'),
                  ),
                  TextButton(
                    onPressed: navigateToLogin,
                    child: const Text('เข้าสู่ระบบ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ],
      ),
    );
  }

  void reg() {
    if (_validateFields()) {
      var data = CustomersRegPostReq(
          fullname: nameNoCtl.text,
          phone: phoneNoCtl.text,
          email: emailNoCtl.text,
          password: passNoCtl.text,
          confirmpassword: confpassNoCtl.text,
          image:
              "http://202.28.34.197:8888/contents/4a00cead-afb3-45db-a37a-c8bebe08fe0d.png");

      http
          .post(Uri.parse('$url/customers'),
              headers: {"Content-Type": "application/json; charset=utf-8"},
              body: jsonEncode(data.toJson()) // Ensure data is properly encoded
              )
          .then((response) {
        if (response.statusCode == 200) {
          dev.log("Registration successful");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ShowTripPage(
                      cid: null,
                    )),
          );
        } else {
          _handleError(response);
        }
      }).catchError((error) {
        dev.log("Error during registration: ${error.toString()}");
        _showSnackBar('เกิดข้อผิดพลาด กรุณาลองอีกครั้งในภายหลัง');
      });
    }
  }

  bool _validateFields() {
    if (nameNoCtl.text.isEmpty ||
        phoneNoCtl.text.isEmpty ||
        emailNoCtl.text.isEmpty ||
        passNoCtl.text.isEmpty ||
        confpassNoCtl.text.isEmpty) {
      _showSnackBar('กรุณากรอกข้อมูลให้ครบทุกช่อง');
      return false;
    }

    if (passNoCtl.text != confpassNoCtl.text) {
      _showSnackBar('รหัสผ่านและการยืนยันรหัสผ่านไม่ตรงกัน');
      return false;
    }

    return true;
  }

  void _handleError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        _showSnackBar('การลงทะเบียนล้มเหลว: ข้อมูลไม่ถูกต้อง');
        break;
      case 409:
        _showSnackBar('การลงทะเบียนล้มเหลว: ข้อมูลซ้ำ');
        break;
      default:
        _showSnackBar('การลงทะเบียนล้มเหลว กรุณาลองอีกครั้ง');
        break;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => loginPage()),
    );
  }
}
