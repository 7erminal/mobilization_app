import 'package:mobilization_app/index.dart';

class PaymentMethodModel {
  String? paymentMethodId;
  String? paymentMethod;
  List<NetworksModel>? networks;

  PaymentMethodModel({
    this.paymentMethodId,
    this.paymentMethod,
    this.networks
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(
      paymentMethodId: json["PaymentMethodId"].toString(),
      paymentMethod: json["PaymentMethod"].toString(),
      networks: json["Networks"] != null ? List<NetworksModel>.from(json["Networks"].map((x) => NetworksModel.fromJson(x))) : null
  );

  Map<String, dynamic> toJson()=> {
    "PaymentMethodId": paymentMethodId,
    "PaymentMethod": paymentMethod,
    "Networks": networks != null ? List<dynamic>.from(networks!.map((x) => x.toJson())) : null,
  };
}