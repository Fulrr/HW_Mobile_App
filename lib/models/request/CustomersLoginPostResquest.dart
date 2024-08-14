// To parse this JSON data, do
//
//     final customersLoginPostResquest = customersLoginPostResquestFromJson(jsonString);

import 'dart:convert';

CustomersLoginPostResquest customersLoginPostResquestFromJson(String str) =>
    CustomersLoginPostResquest.fromJson(json.decode(str));

String customersLoginPostResquestToJson(CustomersLoginPostResquest data) =>
    json.encode(data.toJson());

class CustomersLoginPostResquest {
  String phone;
  String password;

  CustomersLoginPostResquest({
    required this.phone,
    required this.password,
  });

  factory CustomersLoginPostResquest.fromJson(Map<String, dynamic> json) =>
      CustomersLoginPostResquest(
        phone: json["phone"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "password": password,
      };
}
