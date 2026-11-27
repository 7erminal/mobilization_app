import 'dart:async';
import 'dart:convert';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

class SystemBloc with ChangeNotifier {
  int logoutTimerValueInMins = 5;
  int sessionTimerValueInMins = 4;
  String username = "terminal";
  String password = "terminal";

  CountdownTimer? countdownTimer;
  static Timer? timer;

  CountdownTimer? sessionCountdownTimer;
  static Timer? sessionTimer;

  updateUsername(String uName, String pName){
    username = uName;
    password = pName;

    notifyListeners();
  }

  startSessionTimer() {

    debugPrint("Session Timer then is ${sessionCountdownTimer?.remaining}");

    sessionTimer?.cancel();
    // sessionCountdownTimer = CountdownTimer(
    //   Duration(minutes: sessionTimerValueInMins), // make the app remain in the background for 5 minutes
    //   const Duration(seconds: 1),
    // );

    sessionTimer = Timer.periodic(Duration(minutes: sessionTimerValueInMins), (_) {
      stopSessionTimer();
    });

    notifyListeners();
  }

  void stopSessionTimer() async {
    debugPrint("Session timeout ended after 1 min");
    sessionCountdownTimer?.cancel();

    await ApiFetcher.instance.login(username: username, password: password, clientId: "889901");
    debugPrint("Logged in again......proceeding to restart timer");
    startSessionTimer();

    notifyListeners();
  }

  void cancelSessionTimer(){
    countdownTimer!.cancel();

    notifyListeners();
  }

  void resetSystemBlock(){
    username = "terminal";
    password = "terminal";

    notifyListeners();
  }
}