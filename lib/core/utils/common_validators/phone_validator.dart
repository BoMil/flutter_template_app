// import 'package:xepp/utils/translations/translation_storage.dart';

// class PhoneValidator {
//   static String? validatePhoneNumber({String? phone, String country = 'NG'}) {
//     if (phone == null || phone.isEmpty) {
//       return TranslationStorage.translation.phoneNumberRequired;
//     }

//     if (country == 'GH') {
//       if (isValidGhanaPhoneNumber(phone)) {
//         return null;
//       } else {
//         return TranslationStorage.translation.phoneNotValid;
//       }
//     }

//     if (country == 'NG') {
//       if (isValidNigerianPhoneNumber(phone)) {
//         return null;
//       } else {
//         return TranslationStorage.translation.phoneNotValid;
//       }
//     }

//     // TODO: Implement ZM
//     if (country == 'ZM') {}

//     return null;
//   }
// }

// bool isValidNigerianPhoneNumber(String phoneNumber) {
//   // OLD IMPLEMENTATION
//   // // Regex za fiksne linije (uključujući novi "02" prefiks)
//   // final RegExp fixedLinePattern = RegExp(r'^(02|0[1-9]{1,2})[0-9]{7}$');
//   // // Regex za mobilne brojeve
//   // final RegExp mobilePattern = RegExp(r'^(070|080|081|090|091)[0-9]{8}$'); // ne moze poceti sa 0
//   // // Regex za besplatne brojeve (toll-free)
//   // final RegExp tollFreePattern = RegExp(r'^0800[0-9]{7}$');

//   // Regex za fiksne linije (npr. 2xxxxxxx ili 1x, 2x, ... bez početnog 0)
//   // final RegExp fixedLinePattern = RegExp(r'^(2|[1-9]{2})[0-9]{7}$');

//   // Regex za mobilne brojeve, 0 ispred je opciona (70, 80, 81, 90, 91 + 8 cifara)
//   final RegExp mobilePattern = RegExp(r'^(0?70|0?80|0?81|0?90|0?91)[0-9]{8}$');

//   // Regex za besplatne brojeve (toll-free) (800 + 7 cifara)
//   // final RegExp tollFreePattern = RegExp(r'^800[0-9]{7}$');

//   // Validacija broja
//   // return fixedLinePattern.hasMatch(phoneNumber) ||
//   //     mobilePattern.hasMatch(phoneNumber) ||
//   //     tollFreePattern.hasMatch(phoneNumber);
//   return mobilePattern.hasMatch(phoneNumber);
// }

// bool isValidGhanaPhoneNumber(String phoneNumber) {
//   // Regex za fiksne linije (uključujući novi "02" prefiks)
//   final RegExp landline = RegExp(r'^0[23][2-9]\d{7}$');
//   // Regex za mobilne brojeve
//   final RegExp mobile = RegExp(r'^0[2357]\d{8}$');
//   // Regex za besplatne brojeve (toll-free)
//   final RegExp tollFree = RegExp(r'^800\d{5}$');
//   final RegExp premium = RegExp(r'^9\d{7}$');

//   // Validacija broja
//   return landline.hasMatch(phoneNumber) ||
//       mobile.hasMatch(phoneNumber) ||
//       tollFree.hasMatch(phoneNumber) ||
//       premium.hasMatch(phoneNumber);
// }
