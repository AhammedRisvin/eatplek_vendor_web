class AllOrdersModel {
  final bool success;
  final String message;
  final AllOrdersData data;

  AllOrdersModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AllOrdersModel.fromJson(Map<String, dynamic> json) => AllOrdersModel(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    data: AllOrdersData.fromJson(json['data'] ?? {}),
  );
}

class AllOrdersData {
  final List<OrderItem> orders;
  final Pagination pagination;

  AllOrdersData({required this.orders, required this.pagination});

  factory AllOrdersData.fromJson(Map<String, dynamic> json) => AllOrdersData(
    orders: (json['orders'] as List? ?? [])
        .map((x) => OrderItem.fromJson(x))
        .toList(),
    pagination: Pagination.fromJson(json['pagination'] ?? {}),
  );
}

class OrderItem {
  final String bookingId;
  final String orderId;
  final String customer;
  final String orderType;
  final double amount;
  final String status;
  final String rawStatus;
  final DateTime createdAt;

  OrderItem({
    required this.bookingId,
    required this.orderId,
    required this.customer,
    required this.orderType,
    required this.amount,
    required this.status,
    required this.rawStatus,
    required this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    bookingId: json['bookingId'] ?? '',
    orderId: json['orderId'] ?? '',
    customer: json['customer'] ?? '',
    orderType: json['orderType'] ?? '',
    amount: (json['amount'] ?? 0).toDouble(),
    status: json['status'] ?? '',
    rawStatus: json['rawStatus'] ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalCount;
  int? limit;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalCount,
    this.limit,
    this.hasNextPage,
    this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    totalCount: json["totalCount"],
    limit: json["limit"],
    hasNextPage: json["hasNextPage"],
    hasPrevPage: json["hasPrevPage"],
  );

  Map<String, dynamic> toJson() => {
    "currentPage": currentPage,
    "totalPages": totalPages,
    "totalCount": totalCount,
    "limit": limit,
    "hasNextPage": hasNextPage,
    "hasPrevPage": hasPrevPage,
  };
}
