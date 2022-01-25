import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyFlutterPlugin {
  static const MethodChannel _channel = MethodChannel('my_flutter_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void playSound() async {
    try {
      await _channel.invokeMethod('playSound');
    } on MissingPluginException catch (error) {
      debugPrint(error.message);
    } on PlatformException catch (error) {
      debugPrint(error.message);
    }
  }
}
