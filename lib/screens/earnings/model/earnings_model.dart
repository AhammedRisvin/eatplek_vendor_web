import 'dart:convert';

EarningsModel earningsModelFromJson(String str) =>
    EarningsModel.fromJson(json.decode(str));

class EarningsModel {
  bool? success;
  String? message;
  EarningsData? data;

  EarningsModel({this.success, this.message, this.data});

  factory EarningsModel.fromJson(Map<String, dynamic> json) => EarningsModel(
    success: json["success"],
    message: json["message"],
    data: EarningsData.fromJson(json["data"]),
  );
}

class EarningsData {
  String? filter;
  List<Order>? orders;
  EarningsPagination? pagination;

  EarningsData({this.filter, this.orders, this.pagination});

  factory EarningsData.fromJson(Map<String, dynamic> json) => EarningsData(
    filter: json["filter"],
    orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
    pagination: EarningsPagination.fromJson(json["pagination"]),
  );
}

class Order {
  String? bookingId;
  String? orderId;
  String? customer;
  String? serviceType;
  int? amount;
  String? paymentMethod;
  DateTime? paidAt;
  String? orderStatus;
  DateTime? createdAt;

  Order({
    this.bookingId,
    this.orderId,
    this.customer,
    this.serviceType,
    this.amount,
    this.paymentMethod,
    this.paidAt,
    this.orderStatus,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    bookingId: json["bookingId"],
    orderId: json["orderId"],
    customer: json["customer"],
    serviceType: json["serviceType"],
    amount: json["amount"],
    paymentMethod: json["paymentMethod"],
    paidAt: DateTime.parse(json["paidAt"]),
    orderStatus: json["orderStatus"],
    createdAt: DateTime.parse(json["createdAt"]),
  );
}

class EarningsPagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  EarningsPagination({this.total, this.page, this.limit, this.totalPages});

  factory EarningsPagination.fromJson(Map<String, dynamic> json) =>
      EarningsPagination(
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
  };
}
