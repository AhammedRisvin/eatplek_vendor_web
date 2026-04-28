// To parse this JSON data, do
//
//     final vendorModel = vendorModelFromJson(jsonString);

import 'dart:convert';

VendorModel vendorModelFromJson(String str) =>
    VendorModel.fromJson(json.decode(str));

String vendorModelToJson(VendorModel data) => json.encode(data.toJson());

class VendorModel {
  bool? success;
  String? message;
  VendorData? data;

  VendorModel({this.success, this.message, this.data});

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : VendorData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class VendorData {
  String? id;
  String? ownerName;
  String? phoneNumber;
  String? email;
  String? restaurantName;
  List<String>? serviceOffered;
  String? fssaiLicenseNumber;
  String? gstNumber;
  Address? address;
  List<OperatingHour>? operatingHours;
  List<BankAccount>? bankAccounts;
  num? commissionRate;
  String? profileImage;
  String? profileImageKitFileId;
  String? restaurantImage;
  String? restaurantImageKitFileId;
  num? averageRating;
  num? reviewCount;
  bool? isActive;
  bool? isVerified;
  String? verificationStatus;
  int? deliveryRadius;
  DateTime? approvedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;
  String? deviceName;
  String? deviceOs;
  String? dialCode;
  List<String>? firebaseTokens;
  String? phone;
  String? fullAddressString;
  String? dataId;

  VendorData({
    this.id,
    this.ownerName,
    this.phoneNumber,
    this.email,
    this.restaurantName,
    this.serviceOffered,
    this.fssaiLicenseNumber,
    this.gstNumber,
    this.address,
    this.operatingHours,
    this.bankAccounts,
    this.commissionRate,
    this.profileImage,
    this.profileImageKitFileId,
    this.restaurantImage,
    this.restaurantImageKitFileId,
    this.averageRating,
    this.reviewCount,
    this.isActive,
    this.isVerified,
    this.verificationStatus,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.deviceName,
    this.deviceOs,
    this.dialCode,
    this.firebaseTokens,
    this.phone,
    this.fullAddressString,
    this.dataId,
    this.deliveryRadius,
  });

  factory VendorData.fromJson(Map<String, dynamic> json) => VendorData(
    id: json["_id"],
    ownerName: json["ownerName"],
    phoneNumber: json["phoneNumber"],
    email: json["email"],
    restaurantName: json["restaurantName"],
    serviceOffered: json["serviceOffered"] == null
        ? []
        : List<String>.from(json["serviceOffered"]!.map((x) => x)),
    fssaiLicenseNumber: json["fssaiLicenseNumber"],
    gstNumber: json["gstNumber"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    operatingHours: json["operatingHours"] == null
        ? []
        : List<OperatingHour>.from(
            json["operatingHours"]!.map((x) => OperatingHour.fromJson(x)),
          ),
    bankAccounts: json["bankAccounts"] == null
        ? []
        : List<BankAccount>.from(
            json["bankAccounts"]!.map((x) => BankAccount.fromJson(x)),
          ),
    commissionRate: json["commissionRate"],
    profileImage: json["profileImage"],
    profileImageKitFileId: json["profileImageKitFileId"],
    restaurantImage: json["restaurantImage"],
    restaurantImageKitFileId: json["restaurantImageKitFileId"],
    averageRating: json["averageRating"],
    reviewCount: json["reviewCount"],
    isActive: json["isActive"],
    deliveryRadius: json["deliveryRadius"],
    isVerified: json["isVerified"],
    verificationStatus: json["verificationStatus"],
    approvedAt: json["approvedAt"] == null
        ? null
        : DateTime.parse(json["approvedAt"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    deviceName: json["deviceName"],
    deviceOs: json["deviceOs"],
    dialCode: json["dialCode"],
    firebaseTokens: json["firebaseTokens"] == null
        ? []
        : List<String>.from(json["firebaseTokens"]!.map((x) => x)),
    phone: json["phone"],
    fullAddressString: json["fullAddressString"],
    dataId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "deliveryRadius": deliveryRadius,
    "ownerName": ownerName,
    "phoneNumber": phoneNumber,
    "email": email,
    "restaurantName": restaurantName,
    "serviceOffered": serviceOffered == null
        ? []
        : List<dynamic>.from(serviceOffered!.map((x) => x)),
    "fssaiLicenseNumber": fssaiLicenseNumber,
    "gstNumber": gstNumber,
    "address": address?.toJson(),
    "operatingHours": operatingHours == null
        ? []
        : List<dynamic>.from(operatingHours!.map((x) => x.toJson())),
    "bankAccounts": bankAccounts == null
        ? []
        : List<dynamic>.from(bankAccounts!.map((x) => x.toJson())),
    "commissionRate": commissionRate,
    "profileImage": profileImage,
    "profileImageKitFileId": profileImageKitFileId,
    "restaurantImage": restaurantImage,
    "restaurantImageKitFileId": restaurantImageKitFileId,
    "averageRating": averageRating,
    "reviewCount": reviewCount,
    "isActive": isActive,
    "isVerified": isVerified,
    "verificationStatus": verificationStatus,
    "approvedAt": approvedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "deviceName": deviceName,
    "deviceOs": deviceOs,
    "dialCode": dialCode,
    "firebaseTokens": firebaseTokens == null
        ? []
        : List<dynamic>.from(firebaseTokens!.map((x) => x)),
    "phone": phone,
    "fullAddressString": fullAddressString,
    "id": dataId,
  };
}

class Address {
  Coordinates? coordinates;
  String? fullAddress;
  String? pincode;
  String? city;
  String? state;

  Address({
    this.coordinates,
    this.fullAddress,
    this.pincode,
    this.city,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    coordinates: json["coordinates"] == null
        ? null
        : Coordinates.fromJson(json["coordinates"]),
    fullAddress: json["fullAddress"],
    pincode: json["pincode"],
    city: json["city"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": coordinates?.toJson(),
    "fullAddress": fullAddress,
    "pincode": pincode,
    "city": city,
    "state": state,
  };
}

class Coordinates {
  String? type;
  List<double>? coordinates;

  Coordinates({this.type, this.coordinates});

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    type: json["type"],
    coordinates: json["coordinates"] == null
        ? []
        : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null
        ? []
        : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}

class BankAccount {
  String? bankName;
  String? accountHolderName;
  String? accountNumber;
  String? ifscCode;
  String? accountType;
  bool? isActive;

  BankAccount({
    this.bankName,
    this.accountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.accountType,
    this.isActive,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
    bankName: json["bankName"],
    accountHolderName: json["accountHolderName"],
    accountNumber: json["accountNumber"],
    ifscCode: json["ifscCode"],
    accountType: json["accountType"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "bankName": bankName,
    "accountHolderName": accountHolderName,
    "accountNumber": accountNumber,
    "ifscCode": ifscCode,
    "accountType": accountType,
    "isActive": isActive,
  };
}

class OperatingHour {
  String? day;
  String? openTime;
  String? closeTime;
  bool? isClosed;

  OperatingHour({this.day, this.openTime, this.closeTime, this.isClosed});

  factory OperatingHour.fromJson(Map<String, dynamic> json) => OperatingHour(
    day: json["day"],
    openTime: json["openTime"],
    closeTime: json["closeTime"],
    isClosed: json["isClosed"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "openTime": openTime,
    "closeTime": closeTime,
    "isClosed": isClosed,
  };
}
