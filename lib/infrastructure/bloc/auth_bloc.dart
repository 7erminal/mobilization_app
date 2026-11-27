import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

class AuthProvider with ChangeNotifier {
  InactivityService? _inactivityService;
  bool _isAuthenticated = false;
  String labyrinth = "";

  bool get isAuthenticated => _isAuthenticated;

  void changeLabyrinth(String newLabyrinth) {
    labyrinth = newLabyrinth;
    notifyListeners();
  }

  void initInactivityTimer(BuildContext context) {
    _inactivityService = InactivityService(inactivityDuration: const Duration(minutes: 3), onInactive: () => logout(context));
    _inactivityService!.startTimer();
  }

  void resetInactivityTimer() {
    _inactivityService?.resetTimer();
  }

  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout(BuildContext context) {
    debugPrint("Logout called");
    _isAuthenticated = false;
    _inactivityService?.dispose();
    userBloc.logout();
    notifyListeners();

    // Navigator.of(context).pushNamedAndRemoveUntil(
    //   HomeScreen.id,
    //       (Route<dynamic> route) => false,
    // );
  }

  @override
  void dispose() {
    _inactivityService?.dispose();
    super.dispose();
  }
}