// To parse this JSON data, do
//
//     final getBannerModel = getBannerModelFromJson(jsonString);

import 'dart:convert';

import '../../dashboard/model/all_orders_model.dart';

GetBannerModel getBannerModelFromJson(String str) =>
    GetBannerModel.fromJson(json.decode(str));

class GetBannerModel {
  bool? success;
  String? message;
  BannerData? data;

  GetBannerModel({this.success, this.message, this.data});

  factory GetBannerModel.fromJson(Map<String, dynamic> json) => GetBannerModel(
    success: json["success"],
    message: json["message"],
    data: BannerData.fromJson(json["data"]),
  );
}

class BannerData {
  List<BannerList>? banners;
  Pagination? pagination;

  BannerData({this.banners, this.pagination});

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
    banners: List<BannerList>.from(
      json["banners"].map((x) => BannerList.fromJson(x)),
    ),
    pagination: Pagination.fromJson(json["pagination"]),
  );
}

class BannerList {
  String? id;
  String? bannerImage;
  DateTime? endDate;
  bool? isPrebookRelated;
  dynamic prebook;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;

  BannerList({
    this.id,
    this.bannerImage,
    this.endDate,
    this.isPrebookRelated,
    this.prebook,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BannerList.fromJson(Map<String, dynamic> json) => BannerList(
    id: json["_id"],
    bannerImage: json["bannerImage"],
    endDate: DateTime.parse(json["endDate"]),
    isPrebookRelated: json["isPrebookRelated"],
    prebook: json["prebook"] ?? '',
    isActive: json["isActive"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );
}
