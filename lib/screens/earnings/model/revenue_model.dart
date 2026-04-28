// import 'dart:convert';

// RevenueModel revenueModelFromJson(String str) => RevenueModel.fromJson(json.decode(str));

// String revenueModelToJson(RevenueModel data) => json.encode(data.toJson());

// class RevenueModel {
//     List<Analytics>? analytics;

//     RevenueModel({
//         this.analytics,
//     });

//     factory RevenueModel.fromJson(Map<String, dynamic> json) => RevenueModel(
//         analytics: json["analytics"] == null ? [] : List<Analytics>.from(json["analytics"]!.map((x) => Analytics.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "analytics": analytics == null ? [] : List<dynamic>.from(analytics!.map((x) => x.toJson())),
//     };
// }

// class Analytics {
//     Data? data;
//     RevenueAnalytics? revenueAnalytics;

//     Analytics({
//         this.data,
//         this.revenueAnalytics,
//     });

//     factory Analytics.fromJson(Map<String, dynamic> json) => Analytics(
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//         revenueAnalytics: json["revenueAnalytics"] == null ? null : RevenueAnalytics.fromJson(json["revenueAnalytics"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "data": data?.toJson(),
//         "revenueAnalytics": revenueAnalytics?.toJson(),
//     };
// }

// class Data {
//     Revenue? revenue;
//     OrderAnyltics? orderAnyltics;
//     UserAnalytics? userAnalytics;
//     FoodAnalytics? foodAnalytics;

//     Data({
//         this.revenue,
//         this.orderAnyltics,
//         this.userAnalytics,
//         this.foodAnalytics,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         revenue: json["revenue"] == null ? null : Revenue.fromJson(json["revenue"]),
//         orderAnyltics: json["orderAnyltics"] == null ? null : OrderAnyltics.fromJson(json["orderAnyltics"]),
//         userAnalytics: json["userAnalytics"] == null ? null : UserAnalytics.fromJson(json["userAnalytics"]),
//         foodAnalytics: json["foodAnalytics"] == null ? null : FoodAnalytics.fromJson(json["foodAnalytics"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "revenue": revenue?.toJson(),
//         "orderAnyltics": orderAnyltics?.toJson(),
//         "userAnalytics": userAnalytics?.toJson(),
//         "foodAnalytics": foodAnalytics?.toJson(),
//     };
// }

// class FoodAnalytics {
// num? currentMonthFoods;
// num? lastMonthFoods;
// num? allMonthsFoods;
// num? percentageDifference;

//     FoodAnalytics({
//         this.currentMonthFoods,
//         this.lastMonthFoods,
//         this.allMonthsFoods,
//         this.percentageDifference,
//     });

//     factory FoodAnalytics.fromJson(Map<String, dynamic> json) => FoodAnalytics(
//         currentMonthFoods: json["currentMonthFoods"],
//         lastMonthFoods: json["lastMonthFoods"],
//         allMonthsFoods: json["allMonthsFoods"],
//         percentageDifference: json["percentageDifference"],
//     );

//     Map<String, dynamic> toJson() => {
//         "currentMonthFoods": currentMonthFoods,
//         "lastMonthFoods": lastMonthFoods,
//         "allMonthsFoods": allMonthsFoods,
//         "percentageDifference": percentageDifference,
//     };
// }

// class OrderAnyltics {
// num? currentMonthOrders;
// num? lastMonthOrders;
// num? allMonthOrders;
// num? orderPercentageDifference;

//     OrderAnyltics({
//         this.currentMonthOrders,
//         this.lastMonthOrders,
//         this.allMonthOrders,
//         this.orderPercentageDifference,
//     });

//     factory OrderAnyltics.fromJson(Map<String, dynamic> json) => OrderAnyltics(
//         currentMonthOrders: json["currentMonthOrders"],
//         lastMonthOrders: json["lastMonthOrders"],
//         allMonthOrders: json["allMonthOrders"],
//         orderPercentageDifference: json["orderPercentageDifference"],
//     );

//     Map<String, dynamic> toJson() => {
//         "currentMonthOrders": currentMonthOrders,
//         "lastMonthOrders": lastMonthOrders,
//         "allMonthOrders": allMonthOrders,
//         "orderPercentageDifference": orderPercentageDifference,
//     };
// }

// class Revenue {
// num? currentMonthIncome;
// num? lastMonthIncome;
// num? allMonthsIncome;
// num? percentageDifference;

//     Revenue({
//         this.currentMonthIncome,
//         this.lastMonthIncome,
//         this.allMonthsIncome,
//         this.percentageDifference,
//     });

//     factory Revenue.fromJson(Map<String, dynamic> json) => Revenue(
//         currentMonthIncome: json["currentMonthIncome"]?.toDouble(),
//         lastMonthIncome: json["lastMonthIncome"],
//         allMonthsIncome: json["allMonthsIncome"]?.toDouble(),
//         percentageDifference: json["percentageDifference"],
//     );

//     Map<String, dynamic> toJson() => {
//         "currentMonthIncome": currentMonthIncome,
//         "lastMonthIncome": lastMonthIncome,
//         "allMonthsIncome": allMonthsIncome,
//         "percentageDifference": percentageDifference,
//     };
// }

// class UserAnalytics {
// num? currentMonthUsers;
// num? lastMonthUsers;
// num? allMonthsUsers;
// num? percentageDifference;

//     UserAnalytics({
//         this.currentMonthUsers,
//         this.lastMonthUsers,
//         this.allMonthsUsers,
//         this.percentageDifference,
//     });

//     factory UserAnalytics.fromJson(Map<String, dynamic> json) => UserAnalytics(
//         currentMonthUsers: json["currentMonthUsers"],
//         lastMonthUsers: json["lastMonthUsers"],
//         allMonthsUsers: json["allMonthsUsers"],
//         percentageDifference: json["percentageDifference"],
//     );

//     Map<String, dynamic> toJson() => {
//         "currentMonthUsers": currentMonthUsers,
//         "lastMonthUsers": lastMonthUsers,
//         "allMonthsUsers": allMonthsUsers,
//         "percentageDifference": percentageDifference,
//     };
// }

// class RevenueAnalytics {
//     List<MonthlyAmount>? monthlyAmounts;

//     RevenueAnalytics({
//         this.monthlyAmounts,
//     });

//     factory RevenueAnalytics.fromJson(Map<String, dynamic> json) => RevenueAnalytics(
//         monthlyAmounts: json["monthlyAmounts"] == null ? [] : List<MonthlyAmount>.from(json["monthlyAmounts"]!.map((x) => MonthlyAmount.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "monthlyAmounts": monthlyAmounts == null ? [] : List<dynamic>.from(monthlyAmounts!.map((x) => x.toJson())),
//     };
// }

// class MonthlyAmount {
//     String? month;
// num? amount;

//     MonthlyAmount({
//         this.month,
//         this.amount,
//     });

//     factory MonthlyAmount.fromJson(Map<String, dynamic> json) => MonthlyAmount(
//         month: json["month"],
//         amount: json["amount"]?.toDouble(),
//     );

//     Map<String, dynamic> toJson() => {
//         "month": month,
//         "amount": amount,
//     };
// }
