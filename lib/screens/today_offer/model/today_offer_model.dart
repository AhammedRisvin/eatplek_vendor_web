import '../../dashboard/model/all_orders_model.dart';

class TodayOfferModel {
  bool? success;
  String? message;
  List<Datum>? data;
  Pagination? pagination;

  TodayOfferModel({this.success, this.message, this.data, this.pagination});

  factory TodayOfferModel.fromJson(Map<String, dynamic> json) =>
      TodayOfferModel(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );
}

class Datum {
  String? foodId;
  String? foodName;
  String? picture;

  Datum({this.foodId, this.foodName, this.picture});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    foodId: json["foodId"],
    foodName: json["foodName"],
    picture: json["picture"],
  );
}
