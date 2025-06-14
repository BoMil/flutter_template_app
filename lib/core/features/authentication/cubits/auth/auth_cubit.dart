import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template_app/config/constants/secure_storage_keys.dart';
import 'package:flutter_template_app/core/features/authentication/models/responses/login_response.dart';
import 'package:jwt_decode/jwt_decode.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FlutterSecureStorage secureStorage;
  AuthCubit({
    required this.secureStorage,
  }) : super(AuthInitial());
  bool redirectToHomeInitialy = true;

  initAuthState() async {
    redirectToHomeInitialy = true;
    bool isTokenSaved = await isTokenSavedAndUserIsValid();
    // debugPrint(' *********** 5. initAuthState isTokenSaved: $isTokenSaved *********');

    if (isTokenSaved) {
      emit(Authenticated());
    } else {
      logout();
    }
  }

  loginUserToApp(LoginResponse loginResponse) async {
    bool isUserValid = false;
    try {
      // Save token and refreshToken
      await secureStorage.write(key: SecureStorageKeys.tokenKey, value: loginResponse.token);
      await secureStorage.write(key: SecureStorageKeys.refreshTokenKey, value: loginResponse.refreshToken);

      isUserValid = await isTokenSavedAndUserIsValid();
    } catch (e) {
      debugPrint('❌ loginUserToApp save tokens failed: ${e.toString()}');
    }

    if (isUserValid) {
      emit(Authenticated());
    } else {
      logout();
    }
  }

  logout() async {
    redirectToHomeInitialy = true;
    clearStorage();
    emit(Unauthenticated());
  }

  clearStorage() async {
    try {
      await secureStorage.delete(key: SecureStorageKeys.tokenKey);
      await secureStorage.delete(key: SecureStorageKeys.refreshTokenKey);
    } catch (e) {
      debugPrint(' clearStorage() FAILED');
    }
  }

  /// Only Customer users can login to the app
  Future<bool> isTokenSavedAndUserIsValid() async {
    try {
      String? userInfo = await secureStorage.read(key: SecureStorageKeys.tokenKey);

      if (userInfo != null && userInfo != '') {
        Map<String, dynamic> payload = Jwt.parseJwt(userInfo);
        String? type = payload['Type'];
        if (type != null && type.toLowerCase() == 'customer') {
          return true;
        }

        // ToastMessage().showErrorToast(text: TranslationStorage.translation.onlyCustomerCanLogin);
        return false;
      }
    } catch (e) {
      debugPrint('Error in isTokenSavedAndUserIsValid: $e');
      return false;
    }

    return false;
  }
}
