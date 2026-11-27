class AccountBalanceModel {
  String? accountStatus;
  double? availableBalance;
  double? clearBalance;
  double? loanBalance;
  double? sharesBalance;

  AccountBalanceModel({
    this.accountStatus,
    this.availableBalance,
    this.clearBalance,
    this.loanBalance,
    this.sharesBalance
  });

  factory AccountBalanceModel.fromJson(Map<String, dynamic> json) => AccountBalanceModel(
    accountStatus: json["AccountStatus"].toString(),
    availableBalance: double.parse(json["AvailableBalance"].toString()),
      clearBalance: double.parse(json["ClearBalance"].toString()),
      loanBalance: double.parse(json["LoanBalance"].toString()),
      sharesBalance: double.parse(json["SharesBalance"].toString())
  );

  Map<String, dynamic> toJson()=> {
    "AccountStatus": accountStatus,
    "AvailableBalance": availableBalance,
    "ClearBalance": clearBalance,
    "LoanBalance": loanBalance,
    "SharesBalance": sharesBalance
  };

}