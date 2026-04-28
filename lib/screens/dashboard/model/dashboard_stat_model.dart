class DashBoardStatsModel {
  final bool success;
  final String message;
  final DashBoardStatsData data;

  DashBoardStatsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashBoardStatsModel.fromJson(Map<String, dynamic> json) =>
      DashBoardStatsModel(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: DashBoardStatsData.fromJson(json['data'] ?? {}),
      );
}

class DashBoardStatsData {
  final int totalOrdersToday;
  final int revenueToday;
  final int pendingOrders;
  final int completedOrders;

  DashBoardStatsData({
    required this.totalOrdersToday,
    required this.revenueToday,
    required this.pendingOrders,
    required this.completedOrders,
  });

  factory DashBoardStatsData.fromJson(Map<String, dynamic> json) =>
      DashBoardStatsData(
        totalOrdersToday: json['totalOrdersToday'] ?? 0,
        revenueToday: json['revenueToday'] ?? 0,
        pendingOrders: json['pendingOrders'] ?? 0,
        completedOrders: json['completedOrders'] ?? 0,
      );
}
