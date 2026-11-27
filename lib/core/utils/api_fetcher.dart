import 'dart:math';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobilization_app/index.dart';
import 'package:provider/provider.dart';

class ApiFetcher {
  ApiFetcher._();

  static final ApiFetcher _instance = ApiFetcher._();
  static ApiFetcher get instance => _instance;

  static bool isNetworkError(dynamic response) {
    if (response is Map) return false;
    final String message = response.toString().toLowerCase();
    return message.contains("cannot connect to server") ||
        message.contains("socketexception") ||
        message.contains("connection refused") ||
        message.contains("connection failed") ||
        message.contains("timed out") ||
        message.contains("timeout") ||
        message.contains("host lookup");
  }

  Future<dynamic> getPaymentMethods({
    required String phoneNumber,
    required String network,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.getPaymentMethods(
          phoneNumber: phoneNumber, network: network);

      debugPrint("Func get payment methods::: ");
      debugPrint("$response");

      if(response.toString().contains("Cannot connect to serverDioException") || response.toString().contains("401") || (response is Map && response['StatusCode'] == 401)){
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: network);
        if(count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return getPaymentMethods(
            phoneNumber: phoneNumber,
            network: network,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      } else {
        if (response['Success'] == true) {
          debugPrint("About to go update payment methods");
          userBloc.updatePaymentMethods(response['Result']);
          return response;
        } else {
          return response;
        }
      }

      return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> deposit({
    required String amount,
    required String phoneNumber,
    required String accountNumber,
    required String paymentNetwork,
    required String network,
    required String destination,
    required String clientcode,
    required String source,
    required String customerName,
    required String customerNumber,
    required int count,
    bool cacheOnFailure = true
  }) async {
    try {
      var response = await ApiServices.deposit(accountNumber: accountNumber, customerName: customerName, customerNumber: customerNumber,
          phoneNumber: phoneNumber, network: network, paymentNetwork: paymentNetwork, source: source, destination: destination, amount: amount, clientcode: clientcode);

      debugPrint("Func deposit::: ");
      debugPrint("$response");

      if(isNetworkError(response) || response.toString().contains("401") || (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientcode);
        if(count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return deposit(
            customerNumber: customerNumber,
              customerName: customerName,
            amount: amount,
              phoneNumber: phoneNumber,
              accountNumber: accountNumber,
              paymentNetwork: paymentNetwork,
              network: network,
              destination: destination,
              clientcode: clientcode,
              source: source,
            count: count_,
            cacheOnFailure: cacheOnFailure,
          );
        } else {
          if (cacheOnFailure && isNetworkError(response)) {
            debugPrint("Caching deposit transaction of $amount due to network failure");
            await userBloc.cacheTransaction({
              "type": "deposit",
              "amount": amount,
              "phoneNumber": phoneNumber,
              "accountNumber": accountNumber,
              "paymentNetwork": paymentNetwork,
              "network": network,
              "destination": destination,
              "clientcode": clientcode,
              "source": source,
              "customerName": customerName,
              "customerNumber": customerNumber,
              "loanId": "",
              "sourceAccount": "",
            });
          }
          if (response is! Map) {
            response = {};
          }
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      } else {
        if (response['Success'] == true) {
          debugPrint("About to go update deposit response");
          userBloc.updateTransactionResp(response['Result']);
          return response;
        } else {
          return response;
        }
      }
      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> loanRepayment({
    required String amount,
    required String phoneNumber,
    required String accountNumber,
    required String customerName,
    required String customerNumber,
    required String loanId,
    required String network,
    required String paymentNetwork,
    required String clientcode,
    required String sourceAccount,
    required int count,
    bool cacheOnFailure = true
  }) async {
    try {
      var response = await ApiServices.loanRepayment(sourceAccount: sourceAccount, accountNumber: accountNumber, customerName: customerName, customerNumber: customerNumber,
          phoneNumber: phoneNumber, loanId: loanId, amount: amount, clientcode: clientcode, network: network, paymentNetwork: paymentNetwork);

      debugPrint("Func loan repayment::: ");
      debugPrint("$response");

      if(isNetworkError(response) || response.toString().contains("401") || (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientcode);
        if(count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return loanRepayment(
            sourceAccount: sourceAccount,
            customerNumber: customerNumber,
              customerName: customerName,
            amount: amount,
              phoneNumber: phoneNumber,
              accountNumber: accountNumber,
              loanId: loanId,
              clientcode: clientcode,
              network: network,
              paymentNetwork: paymentNetwork,
            count: count_,
            cacheOnFailure: cacheOnFailure,
          );
        } else {
          if (cacheOnFailure && isNetworkError(response)) {
            debugPrint("Caching loan transaction of $amount due to network failure");
            await userBloc.cacheTransaction({
              "type": "loan",
              "amount": amount,
              "phoneNumber": phoneNumber,
              "accountNumber": accountNumber,
              "paymentNetwork": paymentNetwork,
              "network": network,
              "destination": accountNumber,
              "clientcode": clientcode,
              "source": sourceAccount,
              "customerName": customerName,
              "customerNumber": customerNumber,
              "loanId": loanId,
              "sourceAccount": sourceAccount,
            });
          }
          if (response is! Map) {
            response = {};
          }
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      } else {
        if (response['Success'] == true) {
          debugPrint("About to go update loan repayment response");
          userBloc.updateTransactionResp(response['Result']);
          return response;
        } else {
          return response;
        }
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> withdrawal({
    required String amount,
    required String phoneNumber,
    required String accountNumber,
    required String paymentNetwork,
    required String network,
    required String source,
    required String destination,
    required String clientcode,
    required int count
  }) async {
    try {
      var response = await ApiServices.withdrawal(accountNumber: accountNumber,
          phoneNumber: phoneNumber, network: network, paymentNetwork: paymentNetwork, source: source, destination: destination, amount: amount, clientcode: clientcode);

      debugPrint("Func withdrawal::: ");
      debugPrint("$response");

      if(response.toString().contains("Cannot connect to serverDioException") || response.toString().contains("401") || (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientcode);
        if(count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return withdrawal(
            amount: amount,
              phoneNumber: phoneNumber,
              accountNumber: accountNumber,
              paymentNetwork: paymentNetwork,
              network: network,
              source: source,
              destination: destination,
              clientcode: clientcode,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      } else {
        if (response['Success'] == true) {
          debugPrint("About to go update withdrawal response");
          return response;
        } else {
          return response;
        }
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> getLoans({
    required String phoneNumber,
    required String accountNumber,
    required String clientCode,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.accountLoans(accountNumber: accountNumber,
          phoneNumber: phoneNumber, clientcode: clientCode);

      debugPrint("Func account Loans::: ");
      debugPrint("$response");

      if(response.toString().contains("Cannot connect to serverDioException") || response.toString().contains("401") || (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        debugPrint("Client code is $clientCode");
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientCode);
        if(count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return getLoans(
              phoneNumber: phoneNumber,
              accountNumber: accountNumber,
            clientCode: clientCode,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      } else {
        if (response['StatusCode'] == true) {
          debugPrint("About to go update deposit response");
          userBloc.updateLoans(response['Result']);
          return response;
        } else {
          return response;
        }
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> getTransactionStatus({
    required String transactionReference,
    required String phoneNumber,
    required String clientCode,
    required int count
  }) async {
    try {
      var response = await ApiServices.getTransactionStatus(transactionReference: transactionReference);

      debugPrint("Get transaction status::: ");
      debugPrint("$response");

      if(response.toString().contains("Cannot connect to serverDioException") || response.toString().contains("401") || (response is Map && response['StatusCode'] == 401)) {
        // userBloc.login("terminal", "terminal");
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientCode);
        if(count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          getTransactionStatus(
              phoneNumber: phoneNumber,
              transactionReference: transactionReference,
              clientCode: clientCode,
              count: count_
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
        }
      } else {
        if (response['Success'] == true) {
          debugPrint("About to go update transaction details response");
          
          userBloc.updateTransactionDetails(response['Result']);

          return response;
        } else {
          return response;
        }
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> login({
    required String username,
    required String password,
    required String clientId,
  }) async {
    try {
      var response = await ApiServices.login(
          username: username, password: password, clientId: clientId);

      debugPrint("Func login::: ");
      debugPrint("$response");

      if(response['StatusCode']==true){
        debugPrint("About to go update login response");
        // bundlesBloc.updateBundles(response['data']);

        userBloc.updateToken(response['Result']['Token']['AccessToken']);
        debugPrint("Token is ${response['Result']['Token']['AccessToken']}");
        debugPrint("Token is ${userBloc.token}");

        await initLocalStorage();

        localStorage.setItem('token', response['Result']['Token']['AccessToken']);
        localStorage.setItem('refreshToken', response['Result']['Token']['RefreshToken']);
        authProvider.login();

        debugPrint("Login successful, token stored in local storage");
        debugPrint("Refresh Token:: ${localStorage.getItem('refreshToken')}");
        debugPrint("Access Token:: ${localStorage.getItem('token')}");

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> refreshToken({
    required String token,
    required String phoneNumber,
    required String clientId,
  }) async {
    try {
      var response = await ApiServices.refreshAccessToken(
          phoneNumber: phoneNumber, token: token, clientId: clientId);

      debugPrint("Func refresh token::: ");
      debugPrint("$response");

      if(response['StatusCode']==true){
        debugPrint("Token refresh successful response");
        // bundlesBloc.updateBundles(response['data']);

        userBloc.updateToken(response['Result']['Token']['AccessToken']);
        debugPrint("Token is ${response['Result']['Token']['AccessToken']}");
        debugPrint("Token is ${userBloc.token}");

        await initLocalStorage();

        localStorage.setItem('token', response['Result']['Token']['AccessToken']);

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> resetPassword({
    required String username,
    required String password,
  }) async {
    try {
      var response = await ApiServices.resetPassword(
          username: username, password: password);

      debugPrint("Func reset password::: ");
      debugPrint("$response");

      // if(response['Success']==true){
      //   debugPrint("About to go update login response");
      //   // bundlesBloc.updateBundles(response['data']);
      //
      //   userBloc.updateToken(response['Result']);
      //   debugPrint("Token is ${response['Result']}");
      //   debugPrint("Token is ${userBloc.token}");
      //
      //   await initLocalStorage();
      //
      //   localStorage.setItem('token', response['Result']);
      //
      //   return response;
      // } else {
      //   return response;
      // }

      return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> getCorporatives({int count = 2}) async {
    try {
      var response = await ApiServices.getCorporatives();

      debugPrint("Func corporatives::: ");
      debugPrint("$response");

      if(response['StatusCode']==true){
        debugPrint("About to go update corporative response");
        // bundlesBloc.updateBundles(response['data']);
        userBloc.updateCorporatives(response['Result']);

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");

      return null;
    }
  }

  Future<dynamic> customerAccounts({
    required String phoneNumber,
    required String clientId,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.customerAccounts(
          phoneNumber: phoneNumber, clientId: clientId);

      debugPrint("$response");

      if (response.toString().contains("Cannot connect to serverDioException") ||
          response.toString().contains("401") ||
          (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientId);
        if (count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return customerAccounts(
            phoneNumber: phoneNumber,
            clientId: clientId,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      }


      if(response['StatusCode']==true){
        debugPrint("About to go update customer accounts response");
        // bundlesBloc.updateBundles(response['data']);
        userBloc.updateCustomerAccounts(response['Result']);

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> userDetails({
    required String phoneNumber,
    required String clientId,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.userDetails(
          phoneNumber: phoneNumber, clientId: clientId);

      debugPrint("Func user details::: ");
      debugPrint("$response");

      if (response.toString().contains("Cannot connect to serverDioException") ||
          response.toString().contains("401") ||
          (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientId);
        if (count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return userDetails(
            phoneNumber: phoneNumber,
            clientId: clientId,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      }

      if(response['Success']==true){
        debugPrint("About to go update user details response");
        // bundlesBloc.updateBundles(response['Result']);
        authProvider.changeLabyrinth("Labyrinth within api fetcher");
        userBloc.updateUser(response['Result']);

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> accountHistory({
    required String accountNumber,
    required String phoneNumber,
    required String clientId,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.customerAccountHistory(
          accountNumber: accountNumber, phoneNumber: phoneNumber, clientId: clientId);

      debugPrint("$response");

      if (response.toString().contains("Cannot connect to serverDioException") ||
          response.toString().contains("401") ||
          (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientId);
        if (count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return accountHistory(
            accountNumber: accountNumber,
            phoneNumber: phoneNumber,
            clientId: clientId,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      }

      if(response['Success']==true){
        debugPrint("About to go update customer account history response");
        // bundlesBloc.updateBundles(response['data']);
        userBloc.updateAccountHistory(response['Result']);

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> agentTransactions({
    required String agentCode,
    required String clientId,
    required String fromDate,
    required String toDate,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.agentTransactions(
          agentCode: agentCode, clientId: clientId, fromDate: fromDate, toDate: toDate);

      debugPrint("Func customer account history::: ");
      debugPrint("$response");
      if (response.toString().contains("Cannot connect to serverDioException") ||
          response.toString().contains("401") ||
          (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: '', clientId: clientId);
        if (count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return agentTransactions(
            agentCode: agentCode,
            clientId: clientId,
            fromDate: fromDate,
            toDate: toDate,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      }

      if(response['Success']==true){
        debugPrint("About to go update customer transaction history response");
        // bundlesBloc.updateBundles(response['data']);
        userBloc.updateAgentTransactions(response['Result']);

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> accountStatement({
    required String accountNumber,
    required String phoneNumber,
    required String clientId,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.customerAccountStatement(
          accountNumber: accountNumber, phoneNumber: phoneNumber, clientId: clientId);

      debugPrint("$response");

      if (response.toString().contains("Cannot connect to serverDioException") ||
          response.toString().contains("401") ||
          (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientId);
        if (count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return accountStatement(
            accountNumber: accountNumber,
            phoneNumber: phoneNumber,
            clientId: clientId,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      }


      if(response['Success']==true){
        debugPrint("About to go update customer account statement response");
        // bundlesBloc.updateBundles(response['data']);
        userBloc.updateAccountStatement(response['Result']);

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> transactionHistory({
    required String phoneNumber,
    required String clientId,
    required String fromDate,
    required String toDate,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.customerTransactionHistory(
          phoneNumber: phoneNumber, clientId: clientId, fromDate: fromDate, toDate: toDate);

      debugPrint("$response");

      if (response.toString().contains("Cannot connect to serverDioException") ||
          response.toString().contains("401") ||
          (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientId);
        if (count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return transactionHistory(
            phoneNumber: phoneNumber,
            clientId: clientId,
            fromDate: fromDate,
            toDate: toDate,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      }


      if(response['Success']==true){
        debugPrint("About to go update customer transaction history response");
        // bundlesBloc.updateBundles(response['data']);
        userBloc.updateCustomerBillerTransactions(response['Result']);

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> accountBalance({
    required String phoneNumber,
    required String clientId,
    required String accountNumber,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.accountBalance(
          phoneNumber: phoneNumber, clientId: clientId, accountNumber: accountNumber);

      debugPrint("Func account balance::: ");
      debugPrint("$response");

      if (response.toString().contains("Cannot connect to serverDioException") ||
          response.toString().contains("401") ||
          (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientId);
        if (count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return accountBalance(
            phoneNumber: phoneNumber,
            clientId: clientId,
            accountNumber: accountNumber,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      }

      if(response['StatusCode']==true){
        debugPrint("About to go update account balance response");
        // bundlesBloc.updateBundles(response['data']);
        userBloc.updateSelectedAccount(response["Result"]);

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> accountDetails({
    required String phoneNumber,
    required String clientId,
    required String accountId,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.accountDetails(
          phoneNumber: phoneNumber, clientId: clientId, accountId: accountId);

      debugPrint("$response");

      if (response.toString().contains("Cannot connect to serverDioException") ||
          response.toString().contains("401") ||
          (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientId);
        if (count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return accountDetails(
            phoneNumber: phoneNumber,
            clientId: clientId,
            accountId: accountId,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      }


      if(response['StatusCode']==true){
        debugPrint("About to go update account details response");
        // bundlesBloc.updateBundles(response['data']);
        userBloc.updateCustomerAccounts(response["Result"]);

        return response;
      } else {
        debugPrint("Failed to fetch account details, resetting selected account");
        userBloc.updateCustomerAccounts([]);
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> nameInquiry({
    required String phoneNumber,
    required String clientId,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.nameInquiry(
          phoneNumber: phoneNumber, clientId: clientId);

      debugPrint("$response");

      if (response.toString().contains("Cannot connect to serverDioException") ||
          response.toString().contains("401") ||
          (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientId);
        if (count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return nameInquiry(
            phoneNumber: phoneNumber,
            clientId: clientId,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      }


      if(response['StatusCode']==true){
        debugPrint("About to go update name inquiry response");
        // bundlesBloc.updateBundles(response['data']);

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> resetPin({
    required String phoneNumber,
    required String clientId,
    required String oldPin,
    required String newPin,
    int count = 2,
  }) async {
    try {
      var response = await ApiServices.resetPin(
          phoneNumber: phoneNumber, clientId: clientId, oldPin: oldPin, newPin: newPin);

      debugPrint("$response");

      if (response.toString().contains("Cannot connect to serverDioException") ||
          response.toString().contains("401") ||
          (response is Map && response['StatusCode'] == 401)) {
        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientId);
        if (count > 0) {
          int count_ = count - 1;
          debugPrint("Count is $count_");
          return resetPin(
            phoneNumber: phoneNumber,
            clientId: clientId,
            oldPin: oldPin,
            newPin: newPin,
            count: count_,
          );
        } else {
          response['Success'] = false;
          response['StatusMessage'] = "Error processing request";
          return response;
        }
      }


      if(response['StatusCode']==true){
        debugPrint("About to go update pin reset response");
        // bundlesBloc.updateBundles(response['data']);

        return response;
      } else {
        return response;
      }

      // return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }

  Future<dynamic> signUp({
    required int clientId,
    required String name,
    required String phoneNumber,
    required String email,
    required String password,
    required String username,
    required String roleId
  }) async {
    try {
      var response = await ApiServices.signUp(
          clientId: clientId, phoneNumber: phoneNumber, name: name, email: email, password: password, username: username, roleId: roleId
      );

      debugPrint("Func register::: ");
      debugPrint("$response");

      if(response['Success']==true){
        debugPrint("Sign up successful");
        // bundlesBloc.updateBundles(response['data']);

        await initLocalStorage();
        var token = localStorage.getItem('refreshToken') ?? '0';
        await refreshToken(token: token, phoneNumber: phoneNumber, clientId: clientId.toString());

        // return response;
      }

      return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return false;
    }
  }

  Future<dynamic> createAccount({
    required int clientId,
    required String phoneNumber
  }) async {
    try {
      var response = await ApiServices.createAccount(
          clientId: clientId, phoneNumber: phoneNumber
      );

      debugPrint("Func register::: ");
      debugPrint("$response");

      // if(response['StatusCode']==true){
      //   debugPrint("Account creation successful");
      //   // bundlesBloc.updateBundles(response['data']);
      //
      //   return response['StatusCode'];
      // } else {
      //   return false;
      // }

      return response;
    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return false;
    }
  }

}
