class BundleObjModel {
  String? display;
  String? value;
  double? amount;

  BundleObjModel({
    this.display,
    this.value,
    this.amount
  });

  factory BundleObjModel.fromJson(Map<String, dynamic> json) => BundleObjModel(
    display: json["Display"].toString(),
    value: json["Value"].toString(),
    amount: double.parse(json["Amount"].toString())
  );

  Map<String, dynamic> toJson()=> {
    "Display": display,
    "Value": value,
    "Amount": amount
  };
}