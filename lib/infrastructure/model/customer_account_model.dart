class CustomerAccountModel {
  String? accountNumber;
  String? accountAlias;
  String? customerName;
  double? balance;
  double? sharesBalance;
  double? loanBalance;
  double? clearBalance;
  double? balanceBefore;
  double? frozenAmount;
  String? accountType;
  String? reference;
  String? clientId;

  CustomerAccountModel({
    this.accountNumber,
    this.accountAlias,
    this.customerName,
    this.balance,
    this.sharesBalance,
    this.loanBalance,
    this.clearBalance,
    this.balanceBefore,
    this.frozenAmount,
    this.accountType,
    this.reference,
    this.clientId
  });

  factory CustomerAccountModel.fromJson(Map<String, dynamic> json) => CustomerAccountModel(
    accountNumber: json["AccountNumber"].toString(),
    accountAlias: json["AccountAlias"].toString(),
    customerName: json["CustomerName"] != null ? json["CustomerName"].toString() : "",
    balance: json["Balance"] != null ? json["Balance"].toDouble() : 0.0,
    sharesBalance: json["SharesBalance"] != null ? json["SharesBalance"].toDouble() : 0.0,
    loanBalance: json["LoanBalance"] != null ? json["LoanBalance"].toDouble() : 0.0,
    clearBalance: json["ClearBalance"] != null ? json["ClearBalance"].toDouble() : 0.0,
    balanceBefore: json["BalanceBefore"] != null ? json["BalanceBefore"].toDouble() : 0.0,
    frozenAmount: json["FrozenAmount"] != null ? json["FrozenAmount"].toDouble() : 0.0,
    accountType: json["AccountType"] != null ? json["AccountType"].toString() : "",
    reference: json["Reference"].toString(),
    clientId: json["ClientId"].toString(),
  );

  Map<String, dynamic> toJson()=> {
    "AccountNumber": accountNumber,
    "AccountAlias": accountAlias,
    "Balance": balance,
    "SharesBalance": sharesBalance,
    "LoanBalance": loanBalance,
    "ClearBalance": clearBalance,
    "BalanceBefore": balanceBefore,
    "FrozenAmount": frozenAmount,
    "AccountType": accountType,
    "Reference": reference,
    "ClientId": clientId,
  };
}