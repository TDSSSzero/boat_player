import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

final class PerTools {
  PerTools._();

  static Future<bool> requestNoti() async {
    try {
      final status = await Permission.notification.request();
      return status == PermissionStatus.granted;
    } on PlatformException {
      return false;
    }
  }


  static Future<bool> areNotificationsEnabled() async {
    try {
      return await Permission.notification.status == PermissionStatus.granted;
    } on PlatformException {
      return false;
    }
  }
}
