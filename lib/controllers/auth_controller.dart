import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../public/config/user_information.dart';

class AuthController extends GetxController {
  final GetStorage _storage = GetStorage();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    final userData = _storage.read('user');
    if (userData != null) {
      currentUser.value =
          UserModel.fromJson(Map<String, dynamic>.from(userData));
    }
  }

  // ─── LOGIN ───────────────────────────────────────
  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await ApiService.dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
          'device_name': 'flutter-app',
        },
      );

      if (response.data['success'] == true) {
        final token = response.data['token'];
        final user = UserModel.fromJson(response.data['user']);

        // API token save karo
        ApiService.saveToken(token);

        // GetStorage mein save karo — SplashController ke liye
        _storage.write('uid', user.id.toString());
        _storage.write('api_token', token);
        _storage.write('role', user.role);
        _storage.write('user', response.data['user']);

        // UserInformation update karo
        UserInformation.User_uId = user.id.toString();
        UserInformation.apiToken = token;
        UserInformation.role = user.role;
        UserInformation.email = user.email;
        UserInformation.fullname = user.name;

        currentUser.value = user;

        // Role ke hisaab se navigate karo
        _navigateByRole(user.role);
      } else {
        errorMessage.value =
            response.data['message'] ?? 'Login failed.';
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        errorMessage.value = 'Invalid email or password.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage.value =
            'Server se connect nahi ho pa raha. Laravel server check karo.';
      } else {
        errorMessage.value =
            e.response?.data['message'] ?? 'Kuch galat hua. Dobara try karo.';
      }
    } catch (e) {
      errorMessage.value = 'Unexpected error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ─── LOGOUT ──────────────────────────────────────
  Future<void> logout() async {
    try {
      await ApiService.dio.post('/logout');
    } catch (_) {}
    finally {
      ApiService.clearToken();
      _storage.remove('uid');
      _storage.remove('api_token');
      _storage.remove('role');
      _storage.remove('user');
      UserInformation.clear();
      currentUser.value = null;
      Get.offAllNamed('/login');
    }
  }

  // ─── ROLE NAVIGATION ─────────────────────────────
  void _navigateByRole(String role) {
    switch (role) {
      case 'teacher':
        Get.offAllNamed('/teahome');
        break;
      case 'student':
        Get.offAllNamed('/sthome');
        break;
      case 'admin':
      default:
        Get.offAllNamed('/teahome');
        break;
    }
  }

  // ─── GET ME ──────────────────────────────────────
  Future<void> getMe() async {
    try {
      final response = await ApiService.dio.get('/me');
      if (response.data['success'] == true) {
        currentUser.value = UserModel.fromJson(response.data['user']);
      }
    } catch (e) {
      print('Get me error: $e');
    }
  }
}