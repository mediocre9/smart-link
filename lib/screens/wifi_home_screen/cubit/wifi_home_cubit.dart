import 'package:bloc/bloc.dart';
import 'package:http/http.dart';

import '../../../config/app_strings.dart';
part 'wifi_home_state.dart';

class WifiHomeCubit extends Cubit<WifiHomeState> {
  WifiHomeCubit() : super(Initial());
  String? baseUrl;

  Future<void> establishConnection() async {
    baseUrl = "http://${AppString.NODEMCU_DEFAULT_IP}/";
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
