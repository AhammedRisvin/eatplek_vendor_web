import '../../dashboard/model/all_orders_model.dart';

class CategoryModel {
  bool? success;
  String? message;
  List<CategoryData>? data;
  Pagination? pagination;

  CategoryModel({this.success, this.message, this.data, this.pagination});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    success: json['success'],
    message: json['message'],
    data: json['data'] == null
        ? []
        : List<CategoryData>.from(
            json['data']!.map((x) => CategoryData.fromJson(x)),
          ),
    pagination: json['pagination'] == null
        ? null
        : Pagination.fromJson(json['pagination']),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    'pagination': pagination?.toJson(),
  };
}

class CategoryData {
  String? categoryName;
  String? image;
  String? description;
  String? id;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryData({
    this.categoryName,
    this.image,
    this.description,
    this.id,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
    categoryName: json['categoryName'],
    image: json['image'],
    description: json['description'],
    id: json['_id'],
    isActive: json['isActive'],
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.tryParse(json['createdAt']),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.tryParse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'image': image,
    'description': description,
    '_id': id,
    'isActive': isActive,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
