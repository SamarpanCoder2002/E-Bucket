import 'package:connectivity/connectivity.dart';

Future<bool> checkCurrentConnectivity() async {
  final ConnectivityResult _connectivityResult =
      await Connectivity().checkConnectivity();

  return _connectivityResult == ConnectivityResult.mobile ||
          _connectivityResult == ConnectivityResult.wifi
      ? true
      : false;
}
