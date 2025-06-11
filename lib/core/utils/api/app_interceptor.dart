import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template_app/config/environment/environment.dart';

class AppInterceptor {
//   final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  AppInterceptor._internal();

  static final AppInterceptor _instance = AppInterceptor._internal();

  factory AppInterceptor() {
    return _instance;
  }

  var dio = Dio(
    BaseOptions(
      contentType: Headers.jsonContentType,
      baseUrl: Environment.serverAddress,
    ),
  );

  /// Flag used to check if the token is refreshing
  bool _isTokenRefreshing = false;

  /// Safe retry request helper for Dio interceptor
  Future<Response<dynamic>> safeRetryRequest(
    RequestOptions requestOptions,
    String newAccessToken,
  ) async {
    try {
      // Clean clone of headers with updated token
      final newHeaders = Map<String, dynamic>.from(requestOptions.headers);
      newHeaders['Authorization'] = 'Bearer $newAccessToken';

      // Prevent retry loops
      if (requestOptions.extra['isRetry'] == true) {
        throw DioException(
          requestOptions: requestOptions,
          message: 'Already retried, skipping to prevent loop.',
        );
      }
      dynamic newData;

      // First check if request is 'Content-Type': 'multipart/form-data'
      // to avoid Error: "Bad state: The FormData has already been finalized. This typically means you are using the same FormData in repeated requests.
      if (requestOptions.contentType != null && requestOptions.contentType!.contains('multipart/form-data')) {
        try {
          final originalFormData = requestOptions.data as FormData;

          // Create new instance of FormData
          newData = FormData();

          // Copy all fields
          newData.fields.addAll(originalFormData.fields);

          // Copy all files
          for (var file in originalFormData.files) {
            final stream = file.value.finalize();
            final bytes = await readStreamToBytes(stream);

            newData.files.add(MapEntry(
              file.key,
              MultipartFile.fromBytes(
                bytes,
                filename: file.value.filename,
                contentType: file.value.contentType,
              ),
            ));
          }
        } catch (e) {
          debugPrint('[safeRetryRequest] ERROR copying FormData: $e');
          rethrow;
        }
      } else {
        newData = _cloneRequestData(requestOptions.data);
      }

      // Prepare Options object
      final retryOptions = Options(
        method: requestOptions.method,
        headers: newHeaders,
        contentType: requestOptions.contentType,
        responseType: requestOptions.responseType,
        followRedirects: requestOptions.followRedirects,
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        extra: {
          ...requestOptions.extra,
          'isRetry': true,
        },
      );

      debugPrint('[safeRetryRequest] Retrying request to: ${requestOptions.uri}');
// debugPrint('locked: request=${dio.interceptors.requestLock.locked}, response=${dio.interceptors.responseLock.locked}, error=${dio.interceptors.errorLock.locked}');
      var newDio = Dio(
        BaseOptions(
          contentType: requestOptions.contentType,
          baseUrl: Environment.serverAddress,
        ),
      );
      newDio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );

      final response = await newDio.request(
        requestOptions.path,
        data: newData,
        queryParameters: requestOptions.queryParameters,
        options: retryOptions,
      );

      debugPrint('[safeRetryRequest] Retry succeeded.');
      return response;
    } on DioException catch (e) {
      debugPrint('[safeRetryRequest] Retry failed with DioException: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('[safeRetryRequest] Retry failed: $e');
      rethrow;
    }
  }

  /// Clones request data safely
  /// Supports Map and other JSON-safe structures
  /// Falls back to original data if cloning fails
  /// Note: FormData must be handled separately outside this method

  dynamic _cloneRequestData(dynamic data) {
    try {
      if (data == null) return null;
      if (data is Map<String, dynamic> || data is List) {
        return json.decode(json.encode(data));
      }
    } catch (e) {
      debugPrint('[cloneRequestData] Failed to clone: $e');
    }
    return data; // fallback
  }

  /// It will intercept every request sent to the server so we can manipulate
  /// with requests before or after they were sent
  initializeInterceptor() {
    // debugPrint(' ******** 2. INIT ITERCEPTOR ******** ');

    _isTokenRefreshing = false;

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client = HttpClient();
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (RequestOptions requestOptions, RequestInterceptorHandler handler) async {
          // Skip token injection if retry
          if (requestOptions.extra['isRetry'] == true) {
            debugPrint('[onRequest] Retry request — skipping token injection.');
            return handler.next(requestOptions);
          }
          // TODO: Get token from secure storage
          String? token = '';

          if (token.isNotEmpty) {
            requestOptions.headers.putIfAbsent('Authorization', () => 'Bearer $token');
          }
          // debugPrint('REQUEST DATA ${requestOptions.data}');
          debugPrint('TOKEN $token');
          // debugPrint('REQUEST[${requestOptions.method}] => PATH: ${requestOptions.path}');

          handler.next(requestOptions);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          // debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException err, ErrorInterceptorHandler handler) async {
          debugPrint(err.message);
          // debugPrint(
          //     'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}, isRetry: ${err.requestOptions.extra['isRetry']}');

          if (err.type == DioExceptionType.connectionError) {
            return handler.reject(DioException(
              requestOptions: err.requestOptions,
              // error: 'No internet connection',
              type: DioExceptionType.connectionError,
            ));
          }

          // Check if token is expired
          if (err.response?.statusCode == 401) {
            // If a 401 response is received, refresh the access token
            if (!_isTokenRefreshing) {
              String newAccessToken = await _refreshToken();
              _isTokenRefreshing = false;

              if (newAccessToken.isEmpty) {
                return handler.next(err);
              }

              // Update the request header with the new access token
              err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

              try {
                final response = await safeRetryRequest(err.requestOptions, newAccessToken);
                return handler.resolve(response);
              } catch (e) {
                if (e is DioException) {
                  return handler.next(e); // in case retry request failed (e.g. 400 Bad Request)
                }

                // In case of any other error, create a new DioException with the original request options and error message
                DioException newDioException = DioException(requestOptions: err.requestOptions, error: e);
                return handler.next(newDioException);
              }
            }
          }

          handler.next(err);
        },
      ),
    );
  }

  Future<Uint8List> readStreamToBytes(Stream<List<int>> stream) async {
    final List<int> bytes = [];
    await for (var chunk in stream) {
      bytes.addAll(chunk);
    }
    return Uint8List.fromList(bytes);
  }

  _logoutUser() {
    _isTokenRefreshing = false;
    // TODO: Implement logout
  }

  Future<String> _refreshToken() async {
    _isTokenRefreshing = true;

    // TODO: Get refresh token from secure storage
    const String? refreshToken = null;
    // debugPrint('^^^^^ _refreshToken() refreshToken $refreshToken');

    if (refreshToken?.isEmpty ?? true) {
      _logoutUser();
      return '';
    }

    // Create new Dio instance
    final dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        baseUrl: Environment.serverAddress,
      ),
    );

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );

    try {
      // TODO: Implement refresh token
      return Future.value('');
    } on DioException catch (e) {
      _handleError(e);
      _logoutUser();
      return '';
    } catch (e) {
      debugPrint('_refreshToken DioException catch 2 ${e.toString()}');
      _logoutUser();
      return '';
    }
  }

  _handleError(DioException error) {
    // TODO: Handle error
  }
}
