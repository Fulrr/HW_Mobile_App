import 'dart:convert';

CustomersRegPostReq customersRegPostReqFromJson(String str) =>
    CustomersRegPostReq.fromJson(json.decode(str));

String customersRegPostReqToJson(CustomersRegPostReq data) =>
    json.encode(data.toJson());

class CustomersRegPostReq {
  String fullname;
  String phone;
  String email;
  String password;
  String confirmpassword;
  String image; // New field

  CustomersRegPostReq({
    required this.fullname,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmpassword,
    this.image = "", // Default to empty string
  });

  factory CustomersRegPostReq.fromJson(Map<String, dynamic> json) =>
      CustomersRegPostReq(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        confirmpassword: json["confirmpassword"],
        image: json["image"] ?? "", // Use empty string if null
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "password": password,
        "confirmpassword": confirmpassword,
        "image": image,
      };
}