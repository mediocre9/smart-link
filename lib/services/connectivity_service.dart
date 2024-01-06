import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkException implements Exception {
  String message;

  NetworkException({this.message = "Network state is offline!"});

  @override
  String toString() => message;
}

abstract interface class IConnectivityService {
  Future<bool> isOffline();
}

class ConnectivityService implements IConnectivityService {
  final Connectivity connectivity = Connectivity();

  ConnectivityService();

  @override
  Future<bool> isOffline() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    return result == ConnectivityResult.none;
  }
}
