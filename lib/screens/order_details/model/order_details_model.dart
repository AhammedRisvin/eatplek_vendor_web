import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

class OrderDetailsModel {
  bool? success;
  String? message;
  OrderDetailsData? data;

  OrderDetailsModel({this.success, this.message, this.data});

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null
            ? OrderDetailsData.fromJson(json["data"])
            : null,
      );
}

class OrderDetailsData {
  String? id;
  String? orderId;
  String? orderStatus;
  String? paymentStatus;
  String? nextStatus;
  List<String>? availableStatuses;
  String? serviceType;
  bool? isPrebook;
  ServiceDetails? serviceDetails;
  dynamic customer;
  List<OrderItem>? items;
  AmountSummary? amountSummary;
  dynamic notes;
  dynamic couponCode;
  num? couponDiscount;
  dynamic rejectionDetails;
  PaymentDetails? paymentDetails;
  DateTime? orderedAt;
  dynamic vendorResponseAt;
  DateTime? updatedAt;

  OrderDetailsData({
    this.id,
    this.orderId,
    this.orderStatus,
    this.paymentStatus,
    this.nextStatus,
    this.availableStatuses,
    this.serviceType,
    this.isPrebook,
    this.serviceDetails,
    this.customer,
    this.items,
    this.amountSummary,
    this.notes,
    this.couponCode,
    this.couponDiscount,
    this.rejectionDetails,
    this.paymentDetails,
    this.orderedAt,
    this.vendorResponseAt,
    this.updatedAt,
  });

  factory OrderDetailsData.fromJson(Map<String, dynamic> json) =>
      OrderDetailsData(
        id: json["id"],
        orderId: json["orderId"],
        orderStatus: json["orderStatus"],
        paymentStatus: json["paymentStatus"],
        nextStatus: json["nextStatus"],
        availableStatuses: json["availableStatuses"] != null
            ? List<String>.from(json["availableStatuses"])
            : [],
        serviceType: json["serviceType"],
        isPrebook: json["isPrebook"],
        serviceDetails: json["serviceDetails"] != null
            ? ServiceDetails.fromJson(json["serviceDetails"])
            : null,
        customer: json["customer"],
        items: json["items"] != null
            ? List<OrderItem>.from(
                json["items"].map((x) => OrderItem.fromJson(x)),
              )
            : [],
        amountSummary: json["amountSummary"] != null
            ? AmountSummary.fromJson(json["amountSummary"])
            : null,
        notes: json["notes"],
        couponCode: json["couponCode"],
        couponDiscount: json["couponDiscount"],
        rejectionDetails: json["rejectionDetails"],
        paymentDetails: json["paymentDetails"] != null
            ? PaymentDetails.fromJson(json["paymentDetails"])
            : null,
        orderedAt: json["orderedAt"] != null
            ? DateTime.tryParse(json["orderedAt"])
            : null,
        vendorResponseAt: json["vendorResponseAt"],
        updatedAt: json["updatedAt"] != null
            ? DateTime.tryParse(json["updatedAt"])
            : null,
      );
}

class OrderItem {
  String? foodId;
  String? foodName;
  String? foodImage;
  String? foodType;
  num? quantity;
  num? basePrice;
  num? effectivePrice;
  num? itemTotal;
  num? packingCharge;
  bool? isPrebook;
  dynamic notes;
  List<Customization>? customizations;
  List<dynamic>? addOns;

  OrderItem({
    this.foodId,
    this.foodName,
    this.foodImage,
    this.foodType,
    this.quantity,
    this.basePrice,
    this.effectivePrice,
    this.itemTotal,
    this.packingCharge,
    this.isPrebook,
    this.notes,
    this.customizations,
    this.addOns,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    foodId: json["foodId"],
    foodName: json["foodName"],
    foodImage: json["foodImage"],
    foodType: json["foodType"],
    quantity: json["quantity"],
    basePrice: json["basePrice"],
    effectivePrice: json["effectivePrice"],
    itemTotal: json["itemTotal"],
    packingCharge: json["packingCharge"],
    isPrebook: json["isPrebook"],
    notes: json["notes"],
    customizations: json["customizations"] != null
        ? List<Customization>.from(
            json["customizations"].map((x) => Customization.fromJson(x)),
          )
        : [],
    addOns: json["addOns"] != null ? List<dynamic>.from(json["addOns"]) : [],
  );
}

class Customization {
  String? name;
  num? price;
  num? quantity;

  Customization({this.name, this.price, this.quantity});

  factory Customization.fromJson(Map<String, dynamic> json) => Customization(
    name: json["name"],
    price: json["price"],
    quantity: json["quantity"],
  );
}

class AmountSummary {
  num? subTotal;
  num? addOnTotal;
  num? customizationTotal;
  num? packingChargeTotal;
  num? discountTotal;
  num? couponDiscount;
  num? taxAmount;
  num? taxPercentage;
  num? grandTotal;
  num? itemCount;

  AmountSummary({
    this.subTotal,
    this.addOnTotal,
    this.customizationTotal,
    this.packingChargeTotal,
    this.discountTotal,
    this.couponDiscount,
    this.taxAmount,
    this.taxPercentage,
    this.grandTotal,
    this.itemCount,
  });

  factory AmountSummary.fromJson(Map<String, dynamic> json) => AmountSummary(
    subTotal: json["subTotal"],
    addOnTotal: json["addOnTotal"],
    customizationTotal: json["customizationTotal"],
    packingChargeTotal: json["packingChargeTotal"],
    discountTotal: json["discountTotal"],
    couponDiscount: json["couponDiscount"],
    taxAmount: json["taxAmount"],
    taxPercentage: json["taxPercentage"],
    grandTotal: json["grandTotal"],
    itemCount: json["itemCount"],
  );
}

class PaymentDetails {
  dynamic transactionId;
  num? amount;
  String? paymentMethod;
  DateTime? paidAt;

  PaymentDetails({
    this.transactionId,
    this.amount,
    this.paymentMethod,
    this.paidAt,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
    transactionId: json["transactionId"],
    amount: json["amount"],
    paymentMethod: json["paymentMethod"],
    paidAt: json["paidAt"] != null ? DateTime.tryParse(json["paidAt"]) : null,
  );
}

class ServiceDetails {
  dynamic address;
  dynamic name;
  dynamic phoneNumber;
  dynamic personCount;
  DateTime? reachTime;
  dynamic vehicleDetails;
  dynamic latitude;
  dynamic longitude;

  ServiceDetails({
    this.address,
    this.name,
    this.phoneNumber,
    this.personCount,
    this.reachTime,
    this.vehicleDetails,
    this.latitude,
    this.longitude,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) => ServiceDetails(
    address: json["address"],
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    personCount: json["personCount"],
    reachTime: json["reachTime"] != null
        ? DateTime.tryParse(json["reachTime"])
        : null,
    vehicleDetails: json["vehicleDetails"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );
}
