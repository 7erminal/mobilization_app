import 'package:mobilization_app/index.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ApiServices {
  static Future<dynamic> getBundles({
    required String phoneNumber,
    required String network,
    required String destination,
    required String clientId
}) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "PhoneNumber": phoneNumber,
      "Network": network,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token",
      "ClientId": clientId
    };

    var body = {
      "destination": destination
    };

    debugPrint("Token is $token");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.getBundles,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
        headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> getPaymentMethods({
    required String phoneNumber,
    required String network,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "PhoneNumber": phoneNumber,
      "Network": network,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };


    debugPrint("Token is $token");
    try {
      dynamic resp = await ApisCaller.instance.getData(
          path: ApiPaths.getPaymentMethods,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          headers: headers
      );
      debugPrint("RESPONSE::: $resp");
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> deposit({
    required String accountNumber,
    required String phoneNumber,
    required String network,
    required String paymentNetwork,
    required String destination,
    required String source,
    required String amount,
    required String customerName,
    required String customerNumber,
    required String clientcode
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "AccountNumber": accountNumber,
      "PhoneNumber": phoneNumber,
      "Network": network,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "destination": destination,
      "source": source,
      "amount": double.parse(amount),
      "client_id": clientcode,
      "payment_method": paymentNetwork,
      "customerName": customerName,
      "customerNumber": customerNumber,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.deposit,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> loanRepayment({
    required String accountNumber,
    required String phoneNumber,
    required String sourceAccount,
    required String customerName,
    required String customerNumber,
    required String loanId,
    required String amount,
    required String clientcode,
    required String paymentNetwork,
    required String network
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "POS",
      "Authorization": "Bearer $token",
      "Network": network,
    };

    var body = {
      "accountNumber": accountNumber,
      "customerName": customerName,
      "customerNumber": customerNumber,
      "amount": amount,
      "clientId": clientcode,
      "loanId": loanId,
      "paymentMethod": paymentNetwork,
      "sourceAccount": sourceAccount
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.loanRepayment,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> withdrawal({
    required String accountNumber,
    required String phoneNumber,
    required String network,
    required String paymentNetwork,
    required String destination,
    required String source,
    required String amount,
    required String clientcode
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "AccountNumber": accountNumber,
      "PhoneNumber": phoneNumber,
      "Network": paymentNetwork,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "destination": destination,
      "amount": double.parse(amount),
      "source": source,
      "client_id": clientcode
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.withdrawal,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> accountLoans({
    required String accountNumber,
    required String phoneNumber,
    required String clientcode
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token",
          "clientId": clientcode,
    };

    var body = {
      "accountNumber": accountNumber,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.loanList,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> getTransactionStatus({
    required String transactionReference,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "SourceSystem": "POS",
      "Authorization": "Bearer $token",
    };

    var body = {
      "transactionReference": transactionReference,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.transactionStatus,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> buyBundle({
    required String phoneNumber,
    required String accountNumber,
    required String network,
    required String paymentNetwork,
    required String destination,
    required String amount,
    required String bundleId,
    required String clientcode
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "PhoneNumber": phoneNumber,
      "AccountNumber": accountNumber,
      "Network": paymentNetwork,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "destination": destination,
      "amount": double.parse(amount),
      "bundle_id": bundleId,
      "client_id": clientcode,
      "network": network
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.buyBundle,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> buyAirtime({
    required String accountNumber,
    required String phoneNumber,
    required String network,
    required String paymentNetwork,
    required String destination,
    required String amount,
    required String clientcode
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "AccountNumber": accountNumber,
      "PhoneNumber": phoneNumber,
      "Network": paymentNetwork,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "destination": destination,
      "amount": double.parse(amount),
      "network": network,
      "client_id": clientcode
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.buyAirtime,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> ecgTopUp({
    required String phoneNumber,
    required String accountNumber,
    required String destination,
    required String paymentNetwork,
    required String amount,
    required String bundleId,
    required String clientcode
  }) async {
    debugPrint("Phone number is $phoneNumber");
    debugPrint("Amount is $amount");
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "PhoneNumber": phoneNumber,
      "AccountNumber": accountNumber,
      "Network": paymentNetwork,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "DestinationAccount": destination,
      "Amount": double.parse(amount),
      "PackageType": bundleId,
      "ClientId": clientcode
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.payECG,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> buyGhanaWater({
    required String phoneNumber,
    required String accountNumber,
    required String network,
    required String destination,
    required String amount,
    required String bundleId,
    required String clientcode,
    required String customerName,
    required String customerEmail
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "PhoneNumber": phoneNumber,
      "AccountNumber": accountNumber,
      "Network": network,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "DestinationAccount": destination,
      "Amount": double.parse(amount),
      "PackageType": bundleId,
      "CLientId": clientcode,
      "CustomerName": customerName,
      "CustomerEmail": customerEmail
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.payWater,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> buyDSTV({
    required String phoneNumber,
    required String accountNumber,
    required String destinationAccount,
    required String paymentNetwork,
    required String amount,
    required String packageType,
    required String clientcode
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "AccountNumber": accountNumber,
      "Network": paymentNetwork,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "DestinationAccount": destinationAccount,
      "Amount": double.parse(amount),
      "PackageType": packageType,
      "ClientId": clientcode
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.payDSTV,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> buyGoTV({
    required String phoneNumber,
    required String accountNumber,
    required String destinationAccount,
    required String paymentNetwork,
    required String amount,
    required String packageType,
    required String clientcode
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "AccountNumber": accountNumber,
      "Network": paymentNetwork,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "DestinationAccount": destinationAccount,
      "Amount": double.parse(amount),
      "PackageType": packageType,
      "ClientId": clientcode
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.payGOTV,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> buyStartimes({
    required String phoneNumber,
    required String accountNumber,
    required String destinationAccount,
    required String amount,
    required String paymentNetwork,
    required String packageType,
    required String clientcode
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "AccountNumber": accountNumber,
      "Network": paymentNetwork,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "DestinationAccount": destinationAccount,
      "Amount": double.parse(amount),
      "PackageType": packageType,
      "ClientId": clientcode
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.payStartimes,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> dstvAccountQuery({
    required String phoneNumber,
    required String network,
    required String accountNumber,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "Network": network,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "account_number": accountNumber,
      "biller_code": network,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.accountQuery,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> gotvAccountQuery({
    required String phoneNumber,
    required String network,
    required String accountNumber,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "Network": network,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "account_number": accountNumber,
      "biller_code": network,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.accountQuery,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> startimesAccountQuery({
    required String phoneNumber,
    required String network,
    required String accountNumber,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "Network": network,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "account_number": accountNumber,
      "biller_code": network,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.accountQuery,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> ecgAccountQuery({
    required String phoneNumber,
    required String network,
    required String accountNumber,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "Network": network,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "account_number": accountNumber,
      "biller_code": network,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.accountQuery,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> waterBillAccountQuery({
    required String phoneNumber,
    required String network,
    required String accountNumber,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "Network": network,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "account_number": accountNumber,
      "biller_code": network,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.accountQuery,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> accountQuery({
    required String phoneNumber,
    required String billerCode,
    required String accountNumber,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "Network": billerCode,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "account_number": accountNumber,
      "biller_code": billerCode,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.accountQuery,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> ghanaWaterAccountQuery({
    required String phoneNumber,
    required String billerCode,
    required String accountNumber,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "Network": billerCode,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "AccountNumber": accountNumber,
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "BillerCode": billerCode
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.ghanaWaterAccountQuery,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> getCorporatives() async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.getCorporatives,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          headers: headers
      );
      debugPrint("Get corporatives api response is $resp[");
      return resp;
    } catch(e){
      debugPrint("An error occurred getting corporatives $e");
      return false;
    }
  }

  static Future<dynamic> login({
    required String username,
    required String password,
    required String clientId,
  }) async {
    var headers = {
      "Username": username,
      "SourceSystem": "POS"
    };

    var body = {
      "Username": username.trim(),
      "Password": password.trim(),
      "ClientId": clientId.trim()
    };

    debugPrint("Body is ");
    debugPrint("$body");

    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.login,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");

      return false;
    }
  }

  static Future<dynamic> refreshAccessToken({
    required String token,
    required String phoneNumber,
    required String clientId,
  }) async {
    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "MOBILE APP",
          "ClientId": clientId,
    };

    var body = {
      "RefreshToken": token,
    };

    debugPrint("Body is ");
    debugPrint("$body");

    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.refreshAccessToken,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> resetPassword({
    required String username,
    required String password,
  }) async {
    var headers = {
      "PhoneNumber": username,
      "SourceSystem": "MOBILE APP"
    };

    var body = {
      "Username": username,
      "NewPassword": password,
    };

    debugPrint("Body is ");
    debugPrint("$body");

    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.resetPassword,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> customerAccounts({
    required String phoneNumber,
    required String clientId,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "MobileNumber": phoneNumber,
      "ClientId": clientId
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.customerAccounts,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> userDetails({
    required String phoneNumber,
    required String clientId,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    debugPrint("Token to get customer details");

    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.userDetails,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> accountBalance({
    required String phoneNumber,
    required String accountNumber,
    required String clientId
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "AccountNumber": accountNumber,
      "ClientId": clientId
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.accountBalance,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      debugPrint("Response for account balance received..");
      return resp;
    } catch(e){
      debugPrint("An error occurred while fetching balance $e");
      return false;
    }
  }

  static Future<dynamic> accountDetails({
    required String phoneNumber,
    required String accountId,
    required String clientId
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "AccountId": accountId,
      "ClientId": clientId
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.accountDetails,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      debugPrint("Response for account balance received..");
      return resp;
    } catch(e){
      debugPrint("An error occurred while fetching balance $e");
      return false;
    }
  }

  static Future<dynamic> customerAccountHistory({
    required String accountNumber,
    required String phoneNumber,
    required String clientId,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    debugPrint("Token to get customer details");

    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "AccountNumber": accountNumber,
    };

    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.customerAccountHistory,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> customerAccountStatement({
    required String accountNumber,
    required String phoneNumber,
    required String clientId,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    debugPrint("Token to get customer statement");

    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "AccountNumber": accountNumber,
      "ClientId": clientId
    };

    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.customerAccountStatement,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> customerTransactionHistory({
    required String phoneNumber,
    required String fromDate,
    required String toDate,
    required String clientId,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    debugPrint("Token to get customer details");

    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.customertransactionHistory,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          // body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> nameInquiry({
    required String phoneNumber,
    required String clientId,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "MobileNumber": phoneNumber,
      "ClientId": clientId
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.nameInquiry,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> resetPin({
    required String phoneNumber,
    required String clientId,
    required String oldPin,
    required String newPin
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "Number": phoneNumber,
      "OldPassword": oldPin,
      "NewPassword": newPin,
      "ClientId": clientId
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.resetPin,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> signUp({
    required int clientId,
    required String phoneNumber,
    required String name,
    String? email,
    required String password,
    required String username,
    required String roleId
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "RequestId": DateTime.now().millisecondsSinceEpoch.toString(),
      "ClientId": clientId,
      "Name": name.trim(),
      "Email": email?.trim(),
      "MobileNumber": phoneNumber.trim(),
      "Password": password.trim(),
      "UserName": username.trim(),
      "Role": roleId.trim(),
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.registerUser,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> createAccount({
    required int clientId,
    required String phoneNumber,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    var headers = {
      "PhoneNumber": phoneNumber,
      "SourceSystem": "WEB",
      "Authorization": "Bearer $token"
    };

    var body = {
      "ClientId": clientId,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.createAccount,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> registerUser({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String password,
    required String username,
    required String dob,
    required String clientCode,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "SourceSystem": "POS",
      "Authorization": "Bearer $token"
    };

    var body = {
      "FirstName": firstName,
      "LastName": lastName,
      "mobileNumber": mobileNumber,
      "password": password,
      "username": username,
      "dob": dob,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.registerUser,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> getAccountLoans({
    required String accountNumber,
    required String clientId,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';
    var headers = {
      "SourceSystem": "POS",
      "Authorization": "Bearer $token"
    };

    var body = {
      "accountNumber": accountNumber,
    };

    debugPrint("Body is ");
    debugPrint("$body");
    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.registerUser,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }

  static Future<dynamic> agentTransactions({
    required String agentCode,
    required String fromDate,
    required String toDate,
    required String clientId,
  }) async {
    await initLocalStorage();
    var token = localStorage.getItem('token') ?? '0';

    debugPrint("Token to get customer details");

    var headers = {
      "SourceSystem": "POS",
      "Authorization": "Bearer $token"
    };

    var body = {
      "AgentCode": agentCode,
      "FromDate": fromDate,
      "ToDate": toDate
    };

    debugPrint("Header is ");
    debugPrint("$headers");
    try {
      dynamic resp = await ApisCaller.instance.postData(
          path: ApiPaths.agentTransactions,
          builder: (data) {
            debugPrint("Data $data");
            return data;
          },
          body: body,
          headers: headers
      );
      return resp;
    } catch(e){
      debugPrint("An error occurred $e");
      return false;
    }
  }
}