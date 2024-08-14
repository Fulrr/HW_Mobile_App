// To parse this JSON data, do
//
//     final tripGetRes = tripGetResFromJson(jsonString);

import 'dart:convert';

List<TripGetRes> tripGetResFromJson(String str) =>
    List<TripGetRes>.from(json.decode(str).map((x) => TripGetRes.fromJson(x)));

String tripGetResToJson(TripGetRes data) => json.encode(data.toJson());

class TripGetRes {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripGetRes({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripGetRes.fromJson(Map<String, dynamic> json) => TripGetRes(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
      };
}
