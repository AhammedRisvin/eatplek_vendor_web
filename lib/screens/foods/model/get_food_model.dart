import '../../dashboard/model/all_orders_model.dart';

class FoodModel {
  bool? success;
  String? message;
  List<FoodData>? data;
  Pagination? pagination;

  FoodModel({this.success, this.message, this.data, this.pagination});

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<FoodData>.from(json["data"]!.map((x) => FoodData.fromJson(x))),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );
}

class FoodData {
  String? id;
  String? foodName;
  Category? category;
  String? type;
  String? foodImage;
  String? imageKitFileId;
  String? description;
  double? basePrice;
  double? discountPrice;
  int? preparationTime;
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
  int? v;

  FoodData({
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
  });

  factory FoodData.fromJson(Map<String, dynamic> json) => FoodData(
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
  };
}

class AddOn {
  String? name;
  int? price;
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

  Category({this.id, this.categoryName, this.image});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["_id"],
    categoryName: json["categoryName"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "categoryName": categoryName,
    "image": image,
  };
}

class Vendor {
  String? id;
  String? restaurantName;

  Vendor({this.id, this.restaurantName});

  factory Vendor.fromJson(Map<String, dynamic> json) =>
      Vendor(id: json["_id"], restaurantName: json["restaurantName"]);

  Map<String, dynamic> toJson() => {
    "_id": id,
    "restaurantName": restaurantName,
  };
}
