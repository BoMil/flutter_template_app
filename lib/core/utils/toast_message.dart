import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Class used as a wrapper arround Toastification package functionality to avoid code repetition
class ToastMessage {
  EdgeInsets toastPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

  showSuccessToast({
    required String text,
    Alignment alignment = Alignment.bottomCenter,
    Duration toastDuration = const Duration(seconds: 5),
  }) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: toastDuration,
      description: Text(text, maxLines: 5),
      alignment: Alignment.bottomCenter,
      direction: TextDirection.ltr,
      showIcon: true, // show or hide the icon
      padding: toastPadding,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  showInfoToast({
    required String text,
    Alignment alignment = Alignment.bottomCenter,
    Duration toastDuration = const Duration(seconds: 5),
  }) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: toastDuration,
      description: Text(text, maxLines: 5),
      alignment: Alignment.bottomCenter,
      direction: TextDirection.ltr,
      showIcon: true, // show or hide the icon
      padding: toastPadding,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,

      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  showErrorToast({
    required String text,
    Alignment alignment = Alignment.bottomCenter,
    Duration toastDuration = const Duration(seconds: 7),
  }) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: toastDuration,
      description: Text(text, maxLines: 5),
      alignment: Alignment.bottomCenter,
      direction: TextDirection.ltr,
      showIcon: true, // show or hide the icon
      padding: toastPadding,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      // showProgressBar: true,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  showWarningToast({
    required String text,
    Alignment alignment = Alignment.bottomCenter,
    Duration toastDuration = const Duration(seconds: 5),
  }) {
    toastification.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: toastDuration,
      description: Text(text, maxLines: 5),
      alignment: Alignment.bottomCenter,
      direction: TextDirection.ltr,
      showIcon: true, // show or hide the icon
      padding: toastPadding,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }
}
