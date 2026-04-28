class AddOnModel {
  final String name;
  String? image;
  final int price;

  AddOnModel({required this.name, this.image, required this.price});

  factory AddOnModel.fromJson(Map<String, dynamic> json) =>
      AddOnModel(name: json["name"], image: json["image"], price: json["price"]);

  Map<String, dynamic> toJson() => {"name": name, "image": image, "price": price};
}
