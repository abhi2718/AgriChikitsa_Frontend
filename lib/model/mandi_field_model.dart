import 'dart:ffi';

class NearbyMandi {
  String id;
  String district;
  String state;
  String market;
  String variety;
  String commodity;
  double distance;
  int maxPrice;
  int minPrice;
  int modalPrice;
  dynamic arrivalDate;

  NearbyMandi(
      {required this.id,
      this.district = "N/A",
      this.state = "N/A",
      this.market = "N/A",
      this.variety = "N/A",
      this.commodity = "N/A",
      this.maxPrice = 0,
      this.minPrice = 0,
      this.modalPrice = 0,
      this.distance = 0.0,
      this.arrivalDate});

  factory NearbyMandi.fromJson(Map<String, dynamic> json) {
    return NearbyMandi(
      id: json['_id'] ?? "",
      district: json['district'] ?? "N/A",
      state: json['state'] ?? "N/A",
      market: json['market'] ?? "N/A",
      variety: json['variety'] ?? "N/A",
      commodity: json['commodity'] ?? "N/A",
      distance: json['distance'] ?? 0.0,
      maxPrice: json['max_price'] ?? 0,
      minPrice: json['min_price'] ?? 0,
      modalPrice: json['modal_price'] ?? 0,
      arrivalDate: json['arrival_date'],
    );
  }
}
