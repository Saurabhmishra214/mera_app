import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.31.162:8000/api';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static final GetStorage _storage = GetStorage();

  // Dio instance with auth token
  static Dio get dio {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Har request mein token automatically add hoga
          final token = _storage.read('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // 401 aaye toh logout kar do
          if (error.response?.statusCode == 401) {
            _storage.erase();
          }
          return handler.next(error);
        },
      ),
    );
    return _dio;
  }

  // Token save karo
  static void saveToken(String token) {
    _storage.write('token', token);
  }

  // Token remove karo
  static void clearToken() {
    _storage.erase();
  }

  // Token check karo
  static String? getToken() {
    return _storage.read('token');
  }

  // Login hai ya nahi
  static bool isLoggedIn() {
    return _storage.read('token') != null;
  }

  // Yeh method add karo existing ApiService mein

// Simple GET
static Future<Map<String, dynamic>> get(String endpoint) async {
  try {
    final response = await dio.get(endpoint);
    return response.data;
  } catch (e) {
    print('GET Error $endpoint: $e');
    return {'error': e.toString()};
  }
}

// Simple POST
static Future<Map<String, dynamic>> post(
    String endpoint, Map<String, dynamic> data) async {
  try {
    final response = await dio.post(endpoint, data: data);
    return response.data;
  } catch (e) {
    print('POST Error $endpoint: $e');
    return {'error': e.toString()};
  }
}
}