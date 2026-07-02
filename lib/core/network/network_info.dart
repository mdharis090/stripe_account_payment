// lib/core/network/network_info.dart
import 'dart:io';

class NetworkInfo {
  static final NetworkInfo _instance = NetworkInfo._internal();
  
  factory NetworkInfo() => _instance;
  
  NetworkInfo._internal();
  
  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}