import '../../dashboard/model/all_orders_model.dart';

class AllOrdersModel {
  bool success;
  String message;
  Data data;

  AllOrdersModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AllOrdersModel.fromJson(Map<String, dynamic> json) => AllOrdersModel(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  List<OrderItem> orders;
  Pagination pagination;

  Data({required this.orders, required this.pagination});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orders: List<OrderItem>.from(
      json["orders"].map((x) => OrderItem.fromJson(x)),
    ),
    pagination: Pagination.fromJson(json["pagination"]),
  );
}
