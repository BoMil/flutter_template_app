// import 'package:xepp/utils/translations/translation_storage.dart';

// class PasswordValidator {
//   static String? validatePassword({String? password}) {
//     if (password == null || password.isEmpty) {
//       return TranslationStorage.translation.passwordRequired;
//     }

//     // (?=.*[A-Z]) - At least one uppercase letter
//     // (?=.*[a-z]) - At least one lowercase letter
//     // (?=.*\d) - At least one digit
//     // (?=.*[!@#$%^&*?~-]) - At least one special character
//     // .{10,} - Minimum 10 characters
//     if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*?~-]).{10,}$').hasMatch(password)) {
//       return TranslationStorage.translation.passwordValidationMessage;
//     }

//     return null;
//   }

//   static String? validateConfirmPassword({required String password, required String repeatPassword}) {
//     if (repeatPassword.isEmpty) {
//       return TranslationStorage.translation.fieldIsRequired;
//     }

//     if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*?~-]).{10,}$').hasMatch(repeatPassword)) {
//       return TranslationStorage.translation.passwordValidationMessage;
//     }

//     if (password != repeatPassword) {
//       return TranslationStorage.translation.confirmPasswordError;
//     }

//     return null;
//   }
// }
