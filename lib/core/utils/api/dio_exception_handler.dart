// import 'package:dio/dio.dart';

// TODO: Implement error handling when add ToastMessage and translation
// class DioExceptionHandler {
//   String handleError(DioException error, {bool ignoreErrors = false}) {
//     // First handle internet connection error
//     if (error.type == DioExceptionType.connectionError) {
//       ToastMessage().showErrorToast(text: TranslationStorage.translation.noInternetConnection);
//       return TranslationStorage.translation.noInternetConnection;
//     }

//     if (ignoreErrors) {
//       return '';
//     }

//     if (error.response?.data is String || error.response?.data == null) {
//       int? statusCode = error.response?.statusCode;

//       if (statusCode == 400) {
//         ToastMessage().showErrorToast(text: TranslationStorage.translation.status400);
//         return TranslationStorage.translation.status400;
//       } else if (statusCode == 401) {
//         ToastMessage().showWarningToast(text: TranslationStorage.translation.status401);
//         return TranslationStorage.translation.status401;
//       } else if (statusCode == 403) {
//         ToastMessage().showErrorToast(text: TranslationStorage.translation.status403);
//         return TranslationStorage.translation.status403;
//       } else if (statusCode == 404) {
//         ToastMessage().showErrorToast(text: TranslationStorage.translation.status404);
//         return TranslationStorage.translation.status404;
//       } else if (statusCode == 405) {
//         ToastMessage().showErrorToast(text: TranslationStorage.translation.status405);
//         return TranslationStorage.translation.status405;
//       } else if (statusCode == 500) {
//         ToastMessage().showErrorToast(text: TranslationStorage.translation.status500);
//         return TranslationStorage.translation.status500;
//       } else if (statusCode == 501) {
//         ToastMessage().showErrorToast(text: TranslationStorage.translation.status501);
//         return TranslationStorage.translation.status501;
//       } else if (statusCode == 502) {
//         ToastMessage().showErrorToast(text: TranslationStorage.translation.status502);
//         return TranslationStorage.translation.status502;
//       } else if (statusCode == 503) {
//         ToastMessage().showErrorToast(text: TranslationStorage.translation.status503);
//         return TranslationStorage.translation.status503;
//       } else if (statusCode == 504) {
//         ToastMessage().showErrorToast(text: TranslationStorage.translation.status504);
//         return TranslationStorage.translation.status504;
//       } else if (statusCode == 505) {
//         ToastMessage().showErrorToast(text: TranslationStorage.translation.status505);
//         return TranslationStorage.translation.status505;
//       } else {
//         ToastMessage().showErrorToast(text: error.message ?? '');
//         return error.message ?? '';
//       }
//     } else if (error.response?.data['errors'] != null) {
//       dynamic errors = error.response?.data['errors'];
//       // Iterate over errors map and display each error message
//       try {
//         String errorMessage = '';
//         errors.forEach((key, value) {
//           ToastMessage().showErrorToast(text: '$key: ${value[0]}');
//           errorMessage = '$key: ${value[0]}';
//         });
//         return errorMessage;
//       } catch (e) {
//         return e.toString();
//       }
//     }
//     // Here starts the error handling related to our server, messages are placed in a 'title' key
//     else if (error.response?.data['title'] != null) {
//       ToastMessage().showErrorToast(text: '${error.response?.data['title']}');
//       return '${error.response?.data['title']}';
//     } else {
//       ToastMessage().showErrorToast(text: TranslationStorage.translation.somethingWrong);
//       return TranslationStorage.translation.somethingWrong;
//     }
//   }
// }
