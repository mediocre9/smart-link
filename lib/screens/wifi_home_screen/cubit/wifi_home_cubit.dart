import 'package:bloc/bloc.dart';
import 'package:http/http.dart';

import '../../../config/strings/strings.dart';
part 'wifi_home_state.dart';

class WifiHomeCubit extends Cubit<WifiHomeState> {
  WifiHomeCubit() : super(Initial());
  String? baseUrl;

  Future<void> establishConnection() async {
    baseUrl = "http://${Strings.microControllerIp}/";
    emit(Connecting());
    try {
      Response response = await get(Uri.parse(baseUrl!));
      if (response.body == "Connected") {
        emit(Connected(baseUrl!));
      }
    } catch (e) {
      emit(NotConnected("Connection failed!"));
      emit(Initial());
    }
  }
}
