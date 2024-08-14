// To parse this JSON data, do
//
//     final customersLoginPostRes = customersLoginPostResFromJson(jsonString);

import 'dart:convert';

CustomersLoginPostRes customersLoginPostResFromJson(String str) =>
    CustomersLoginPostRes.fromJson(json.decode(str));

String customersLoginPostResToJson(CustomersLoginPostRes data) =>
    json.encode(data.toJson());

class CustomersLoginPostRes {
  String message;
  Customer customer;

  CustomersLoginPostRes({
    required this.message,
    required this.customer,
  });

  factory CustomersLoginPostRes.fromJson(Map<String, dynamic> json) =>
      CustomersLoginPostRes(
        message: json["message"],
        customer: Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "customer": customer.toJson(),
      };
}

class Customer {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  Customer({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
      };
}
