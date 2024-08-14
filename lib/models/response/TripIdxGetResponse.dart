import 'dart:convert';

List<TripIdxGetResponse> tripIdxGetResponseFromJson(String str) =>
    List<TripIdxGetResponse>.from(
      (json.decode(str) as List<dynamic>).map((x) => TripIdxGetResponse.fromJson(x as Map<String, dynamic>))
    );

String tripIdxGetResponseToJson(List<TripIdxGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripIdxGetResponse {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripIdxGetResponse({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripIdxGetResponse.fromJson(Map<String, dynamic> json) => TripIdxGetResponse(
    idx: json["idx"] as int,
    name: json["name"] as String,
    country: json["country"] as String,
    coverimage: json["coverimage"] as String,
    detail: json["detail"] as String,
    price: json["price"] as int,
    duration: json["duration"] as int,
    destinationZone: json["destination_zone"] as String,
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