import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class CookieManager {
  CookieManager._();

  static const String _METHOD_SAVECOOKIES = 'saveCookies';
  static const String _METHOD_LOADCOOKIES = 'loadCookies';
  static const String _METHOD_REMOVEALLCOOKIES = 'removeAllCookies';

  static const String _ARGUMENT_KEY_URL = 'url';
  static const String _ARGUMENT_KEY_COOKIES = 'cookies';

  static const MethodChannel _channel =
      MethodChannel('v7lin.github.io/cookie_manager_kit');

  static Future<void> saveCookies({
    required String url,
    required List<Cookie> cookies,
  }) {
    return _channel.invokeMethod<void>(
      _METHOD_SAVECOOKIES,
      <String, dynamic>{
        _ARGUMENT_KEY_URL: url,
        _ARGUMENT_KEY_COOKIES: cookies.map((Cookie cookie) {
          return cookie.toString();
        }).toList(),
      },
    );
  }

  static Future<List<Cookie>?> loadCookies({
    required String url,
  }) async {
    final List<dynamic>? cookies = await _channel.invokeListMethod<dynamic>(
      _METHOD_LOADCOOKIES,
      <String, dynamic>{
        _ARGUMENT_KEY_URL: url,
      },
    );
    return (cookies?.isNotEmpty ?? false)
        ? cookies!.map((dynamic cookie) {
            return Cookie.fromSetCookieValue(cookie as String);
          }).toList()
        : null;
  }

  static Future<void> clearAllCookies() {
    return _channel.invokeMethod<void>(_METHOD_REMOVEALLCOOKIES);
  }
}
