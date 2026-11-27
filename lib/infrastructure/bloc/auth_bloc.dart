import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

class AuthProvider with ChangeNotifier {
  InactivityService? _inactivityService;
  bool _isAuthenticated = false;
  String labyrinth = "";

  bool get isAuthenticated => _isAuthenticated;

  /// Rotates the tracing session id (X-Session-Id) when the app has been in
  /// the background for [TracingConfig.sessionInactivityTimeout]. Registered
  /// in main.dart; see [SessionLifecycleObserver].
  final SessionLifecycleObserver sessionLifecycleObserver =
      SessionLifecycleObserver();

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

    // Rotate the tracing session id (X-Session-Id) on logout. A new one is
    // minted on the next successful login (also covers "login as a
    // different user").
    sessionService.endSession(SessionRotationReason.logout);

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
    WidgetsBinding.instance.removeObserver(sessionLifecycleObserver);
    _inactivityService?.dispose();
    super.dispose();
  }
}

/// Bridges app lifecycle changes to [SessionService] so the tracing session
/// id rotates after [TracingConfig.sessionInactivityTimeout] of app
/// inactivity (app in the background). Instantiated by [AuthProvider] and
/// registered with `WidgetsBinding` in main.dart.
class SessionLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        sessionService.markBackgrounded();
        break;
      case AppLifecycleState.resumed:
        sessionService.markResumed();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }
}
