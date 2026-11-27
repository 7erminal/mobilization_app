import 'package:dio/dio.dart';
import 'package:mobilization_app/index.dart';

class ApisCaller {
  ApisCaller._() {
    dio = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60), // 60 seconds
        receiveTimeout: const Duration(seconds: 60), // 60 seconds
      ),
    );
    // Adds X-Session-Id / X-Trace-Id / X-Request-Id to every request to a
    // configured backend host, and structured request logs. Requests to
    // third-party hosts are passed through untouched.
    dio.interceptors.add(TracingInterceptor(sessionService: sessionService));
  }

  static final instance = ApisCaller._();

  late Dio dio;

  // get data from api
  Future<T> getData<T>({
    required String path,
    Map<String, String>? queryParameters,
    required T Function(dynamic data) builder,
    Map<String, dynamic>? headers
  }) async {
    try {
      print("api path: $path ... ");
      print("parameters are $queryParameters");
      Response response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return builder(response.data);
    } catch (e) {
      print(e.toString());
      final errorMessage = Exceptions.errorMessage(e);
      final failure = ServerFailure(
        message: errorMessage,
        requestId: Exceptions.extractRequestId(e),
      );
      return builder(failure);
    }
  }

  // post data to api
  Future<T> postData<T>({
    required String path,
    dynamic? queryParameters,
    Map<String, dynamic>? body,
    required T Function(dynamic data) builder,
    Map<String, dynamic>? headers
  }) async {
    try {
      print("api path: $path ... ");
      // print("User token is ${userActor.userModel.token}");
      print("Params are $body or $queryParameters");
      // print();
      Response response = await dio.post(
        // options: Options(headers: {
        //   HttpHeaders.contentTypeHeader: "application/json",
        // }),
        path,
        // data: queryParameters,
        data: queryParameters ?? body,
        options: Options(headers: headers),
      );
      return builder(response.data);
    } catch (e) {
      print("Error RECEIVED");
      print(e.toString());
      final errorMessage = Exceptions.errorMessage(e);
      final failure = ServerFailure(
        message: errorMessage,
        requestId: Exceptions.extractRequestId(e),
      );
      return builder(failure);
    }
  }

  // put data to api
  Future<T> putData<T>({
    required String path,
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
    required T Function(dynamic data) builder,
    Map<String, dynamic>? headers
  }) async {
    try {
      print("api path: $path ... ");

      print("Params are $body or $queryParameters");
      Response response = await dio.put(
        path,
        queryParameters: queryParameters,
        data: body,
        // options: Options(headers: {
        //   // 'Authorization': "Bearer ${userActor.userModel.token}"
        // }),
        options: Options(headers: headers),
      );
      return builder(response.data);
    } catch (e) {
      // debugPrint(e.toString());
      final errorMessage = Exceptions.errorMessage(e);
      final failure = ServerFailure(
        message: errorMessage,
        requestId: Exceptions.extractRequestId(e),
      );
      return builder(failure);
    }
  }

  // patch data to api
  Future<T> patchData<T>({
    required String path,
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
    required T Function(dynamic data) builder,
    Map<String, dynamic>? headers
  }) async {
    try {
      print("api path: $path ... ");
      Response response = await dio.patch(
        path,
        queryParameters: queryParameters,
        data: body,
        options: Options(headers: headers),
      );
      return builder(response.data);
    } catch (e) {
      // debugPrint(e.toString());
      final errorMessage = Exceptions.errorMessage(e);
      final failure = ServerFailure(
        message: errorMessage,
        requestId: Exceptions.extractRequestId(e),
      );
      return builder(failure);
    }
  }

  // delete data from api
  Future<T> deleteData<T>({
    required String path,
    Map<String, String>? queryParameters,
    required T Function(dynamic data) builder,
    Map<String, dynamic>? headers
  }) async {
    try {
      print("api path: $path ... ");
      Response response = await dio.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return builder(response.data);
    } catch (e) {
      // debugPrint(e.toString());
      final errorMessage = Exceptions.errorMessage(e);
      final failure = ServerFailure(
        message: errorMessage,
        requestId: Exceptions.extractRequestId(e),
      );
      return builder(failure);
    }
  }
}