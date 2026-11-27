import 'package:mobilization_app/index.dart';


UserBloc userBloc = UserBloc();
SystemBloc systemBloc = SystemBloc();
AuthProvider authProvider = AuthProvider();

/// Global tracing session owner (X-Session-Id). Hooked into login/logout in
/// [AuthProvider] / ApiFetcher, and read by the TracingInterceptor.
SessionService sessionService = SessionService();
