import 'dart:convert';

EarningStatsModel earningStatsModelFromJson(String str) =>
    EarningStatsModel.fromJson(json.decode(str));

class EarningStatsModel {
  bool? success;
  String? message;
  EarningStatsData? data;

  EarningStatsModel({this.success, this.message, this.data});

  factory EarningStatsModel.fromJson(Map<String, dynamic> json) =>
      EarningStatsModel(
        success: json["success"],
        message: json["message"],
        data: EarningStatsData.fromJson(json["data"]),
      );
}

class EarningStatsData {
  String? filter;
  int? commissionRate;
  int? totalRevenue;
  int? adminCommission;
  int? totalEarnings;
  int? totalPaid;
  int? pendingPayout;
  int? totalOrders;
  int? pendingOrders;

  EarningStatsData({
    this.filter,
    this.commissionRate,
    this.totalRevenue,
    this.adminCommission,
    this.totalEarnings,
    this.totalPaid,
    this.pendingPayout,
    this.totalOrders,
    this.pendingOrders,
  });

  factory EarningStatsData.fromJson(Map<String, dynamic> json) =>
      EarningStatsData(
        filter: json["filter"],
        commissionRate: json["commissionRate"],
        totalRevenue: json["totalRevenue"],
        adminCommission: json["adminCommission"],
        totalEarnings: json["totalEarnings"],
        totalPaid: json["totalPaid"],
        pendingPayout: json["pendingPayout"],
        totalOrders: json["totalOrders"],
        pendingOrders: json["pendingOrders"],
      );
}
