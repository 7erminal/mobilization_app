class DepositReceiptModel {
  String? accountNumber;
  String? accountAlias;
  double? balance;
  double? balanceBefore;
  double? frozenAmount;

  DepositReceiptModel({
    this.accountNumber,
    this.accountAlias,
    this.balance,
    this.balanceBefore,
    this.frozenAmount
  });

  factory DepositReceiptModel.fromJson(Map<String, dynamic> json) => DepositReceiptModel(
    accountNumber: json["AccountNumber"].toString(),
    accountAlias: json["AccountAlias"].toString(),
    balance: json["Balance"].toDouble(),
    balanceBefore: json["BalanceBefore"].toDouble(),
    frozenAmount: json["FrozenAmount"].toDouble(),
  );

  Map<String, dynamic> toJson()=> {
    "AccountNumber": accountNumber,
    "AccountAlias": accountAlias,
    "Balance": balance,
    "BalanceBefore": balanceBefore,
    "FrozenAmount": frozenAmount
  };
}