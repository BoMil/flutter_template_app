
// class EmailValidator {
//   static String? validateEmail({String? email}) {
//     if (email == null || email.isEmpty) {
//       return TranslationStorage.translation.emailRequired;
//     }

//     if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(?:\.[a-zA-Z]{2,})?$').hasMatch(email)) {
//       return TranslationStorage.translation.enterValidEmail;
//     }

//     return null;
//   }
// }
