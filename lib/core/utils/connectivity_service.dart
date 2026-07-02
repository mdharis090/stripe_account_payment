import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  StreamSubscription<InternetConnectionStatus>? _internetSub;

  ConnectivityService() {
    _init();
  }

  void _init() {
    // Listen to connectivity changes
    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
      _checkInternet();
    });

    // Also listen to the internet connection checker
    _internetSub = InternetConnectionChecker().onStatusChange.listen((status) {
      final online = status == InternetConnectionStatus.connected;
      if (online != _isOnline) {
        _isOnline = online;
        notifyListeners();
      }
    });

    // initial check
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    final has = await InternetConnectionChecker().hasConnection;
    if (has != _isOnline) {
      _isOnline = has;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _internetSub?.cancel();
    super.dispose();
  }
}
