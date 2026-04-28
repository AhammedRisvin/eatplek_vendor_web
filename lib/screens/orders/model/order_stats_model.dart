import 'dart:convert';

OrderStatsModel orderStatsModelFromJson(String str) =>
    OrderStatsModel.fromJson(json.decode(str));

class OrderStatsModel {
  bool? success;
  String? message;
  OrderStatsData? data;

  OrderStatsModel({this.success, this.message, this.data});

  factory OrderStatsModel.fromJson(Map<String, dynamic> json) =>
      OrderStatsModel(
        success: json["success"],
        message: json["message"],
        data: OrderStatsData.fromJson(json["data"]),
      );
}

class OrderStatsData {
  int? totalOrdersToday;
  int? pendingOrders;
  int? cancelledOrders;
  int? completedOrders;

  OrderStatsData({
    this.totalOrdersToday,
    this.pendingOrders,
    this.cancelledOrders,
    this.completedOrders,
  });

  factory OrderStatsData.fromJson(Map<String, dynamic> json) => OrderStatsData(
    totalOrdersToday: json["totalOrdersToday"],
    pendingOrders: json["pendingOrders"],
    cancelledOrders: json["cancelledOrders"],
    completedOrders: json["completedOrders"],
  );
}
