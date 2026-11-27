class AccountQueryModel {
  String? name;
  String? amount;
  String? account;
  String? package;

  AccountQueryModel({
    this.name,
    this.amount,
    this.account,
    this.package
  });

  factory AccountQueryModel.fromJson(Map<String, dynamic> json) => AccountQueryModel(
      name: json["name"].toString(),
      amount: json["amount"].toString(),
      account: json["accountNumber"].toString(),
    package: json["package"].toString()
  );

  Map<String, dynamic> toJson()=> {
    "Name": name,
    "Amount": amount,
    "AccountNumber": account,
    "Package": package
  };
}