// To parse this JSON data, do
//
//     final foodDetailModel = foodDetailModelFromJson(jsonString);

import 'dart:convert';

FoodDetailModel foodDetailModelFromJson(String str) =>
    FoodDetailModel.fromJson(json.decode(str));

class FoodDetailModel {
  bool? success;
  String? message;
  Data? data;
  MoreDetails? moreDetails;

  FoodDetailModel({this.success, this.message, this.data, this.moreDetails});

  factory FoodDetailModel.fromJson(Map<String, dynamic> json) =>
      FoodDetailModel(
        success: json["success"],
        message: json["message"],
        moreDetails: MoreDetails.fromJson(json["moreDetails"]),

        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  String? id;
  String? foodName;
  Category? category;
  String? type;
  String? foodImage;
  String? imageKitFileId;
  String? description;
  num? basePrice;
  num? discountPrice;
  num? preparationTime;
  List<String>? orderTypes;
  List<AddOn>? addOns;
  List<dynamic>? dayOffers;
  Vendor? vendor;
  bool? isPrebook;
  DateTime? prebookStartDate;
  DateTime? prebookEndDate;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;
  List<dynamic>? customizations;
  num? effectivePrice;
  num? discountPercentage;
  String? dataId;

  Data({
    this.id,
    this.foodName,
    this.category,
    this.type,
    this.foodImage,
    this.imageKitFileId,
    this.description,
    this.basePrice,
    this.discountPrice,
    this.preparationTime,
    this.orderTypes,
    this.addOns,
    this.dayOffers,
    this.vendor,
    this.isPrebook,
    this.prebookStartDate,
    this.prebookEndDate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.customizations,
    this.effectivePrice,
    this.discountPercentage,
    this.dataId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    foodName: json["foodName"],
    category: json["category"] == null
        ? null
        : Category.fromJson(json["category"]),
    type: json["type"],
    foodImage: json["foodImage"],
    imageKitFileId: json["imageKitFileId"],
    description: json["description"],
    basePrice: json["basePrice"]?.toDouble(),
    discountPrice: json["discountPrice"]?.toDouble(),
    preparationTime: json["preparationTime"],
    orderTypes: json["orderTypes"] == null
        ? []
        : List<String>.from(json["orderTypes"]!.map((x) => x)),
    addOns: json["addOns"] == null
        ? []
        : List<AddOn>.from(json["addOns"]!.map((x) => AddOn.fromJson(x))),
    dayOffers: json["dayOffers"] == null
        ? []
        : List<dynamic>.from(json["dayOffers"]!.map((x) => x)),
    vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
    isPrebook: json["isPrebook"],
    prebookStartDate: json["prebookStartDate"] == null
        ? null
        : DateTime.parse(json["prebookStartDate"]),
    prebookEndDate: json["prebookEndDate"] == null
        ? null
        : DateTime.parse(json["prebookEndDate"]),
    isActive: json["isActive"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    customizations: json["customizations"] == null
        ? []
        : List<dynamic>.from(json["customizations"]!.map((x) => x)),
    effectivePrice: json["effectivePrice"]?.toDouble(),
    discountPercentage: json["discountPercentage"],
    dataId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "foodName": foodName,
    "category": category?.toJson(),
    "type": type,
    "foodImage": foodImage,
    "imageKitFileId": imageKitFileId,
    "description": description,
    "basePrice": basePrice,
    "discountPrice": discountPrice,
    "preparationTime": preparationTime,
    "orderTypes": orderTypes == null
        ? []
        : List<dynamic>.from(orderTypes!.map((x) => x)),
    "addOns": addOns == null
        ? []
        : List<dynamic>.from(addOns!.map((x) => x.toJson())),
    "dayOffers": dayOffers == null
        ? []
        : List<dynamic>.from(dayOffers!.map((x) => x)),
    "vendor": vendor?.toJson(),
    "isPrebook": isPrebook,
    "prebookStartDate": prebookStartDate?.toIso8601String(),
    "prebookEndDate": prebookEndDate?.toIso8601String(),
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "customizations": customizations == null
        ? []
        : List<dynamic>.from(customizations!.map((x) => x)),
    "effectivePrice": effectivePrice,
    "discountPercentage": discountPercentage,
    "id": dataId,
  };
}

class AddOn {
  String? name;
  num? price;
  String? image;
  dynamic imageKitFileId;
  String? id;

  AddOn({this.name, this.price, this.image, this.imageKitFileId, this.id});

  factory AddOn.fromJson(Map<String, dynamic> json) => AddOn(
    name: json["name"],
    price: json["price"],
    image: json["image"],
    imageKitFileId: json["imageKitFileId"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "image": image,
    "imageKitFileId": imageKitFileId,
    "_id": id,
  };
}

class Category {
  String? id;
  String? categoryName;
  String? image;
  String? description;
  String? categoryId;

  Category({
    this.id,
    this.categoryName,
    this.image,
    this.description,
    this.categoryId,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["_id"],
    categoryName: json["categoryName"],
    image: json["image"],
    description: json["description"],
    categoryId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "categoryName": categoryName,
    "image": image,
    "description": description,
    "id": categoryId,
  };
}

class Vendor {
  String? id;
  String? ownerName;
  String? restaurantName;
  Address? address;
  String? profileImage;
  String? restaurantImage;
  String? fullAddressString;
  String? vendorId;

  Vendor({
    this.id,
    this.ownerName,
    this.restaurantName,
    this.address,
    this.profileImage,
    this.restaurantImage,
    this.fullAddressString,
    this.vendorId,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
    id: json["_id"],
    ownerName: json["ownerName"],
    restaurantName: json["restaurantName"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    profileImage: json["profileImage"],
    restaurantImage: json["restaurantImage"],
    fullAddressString: json["fullAddressString"],
    vendorId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "ownerName": ownerName,
    "restaurantName": restaurantName,
    "address": address?.toJson(),
    "profileImage": profileImage,
    "restaurantImage": restaurantImage,
    "fullAddressString": fullAddressString,
    "id": vendorId,
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

class MoreDetails {
  int? totalOrders;
  int? todayOrders;
  int? revenueGenerated;
  OrdersByServiceType? ordersByServiceType;

  MoreDetails({
    this.totalOrders,
    this.todayOrders,
    this.revenueGenerated,
    this.ordersByServiceType,
  });

  factory MoreDetails.fromJson(Map<String, dynamic> json) => MoreDetails(
    totalOrders: json["totalOrders"],
    todayOrders: json["todayOrders"],
    revenueGenerated: json["revenueGenerated"],
    ordersByServiceType: OrdersByServiceType.fromJson(
      json["ordersByServiceType"],
    ),
  );
}

class OrdersByServiceType {
  int? dineIn;
  int? delivery;
  int? takeaway;
  int? pickup;
  int? carDineIn;

  OrdersByServiceType({
    this.dineIn,
    this.delivery,
    this.takeaway,
    this.pickup,
    this.carDineIn,
  });

  factory OrdersByServiceType.fromJson(Map<String, dynamic> json) =>
      OrdersByServiceType(
        dineIn: json["Dine in"],
        delivery: json["Delivery"],
        takeaway: json["Takeaway"],
        pickup: json["Pickup"],
        carDineIn: json["Car Dine in"],
      );
}
