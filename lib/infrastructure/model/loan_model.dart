class LoanModel {
  String? LoanId;
  String? LoanType;
  String? LoanBalance;

  LoanModel({
    this.LoanId,
    this.LoanType,
    this.LoanBalance,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) => LoanModel(
    LoanId: json["LoanId"].toString(),
    LoanType: json["LoanType"].toString(),
    LoanBalance: json["LoanBal"].toString(),
  );

  Map<String, dynamic> toJson()=> {
    "NetworkId": LoanId,
    "NetworkName": LoanType,
    "NetworkCode": LoanBalance,
  };
}