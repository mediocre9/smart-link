import 'package:app_settings/app_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';

import '../../../config/strings/app_strings.dart';
part 'wifi_home_state.dart';

class WifiHomeCubit extends Cubit<WifiHomeState> {
  WifiHomeCubit() : super(Initial());
  String? baseUrl;

  Future<void> connectToESP8266() async {
    baseUrl = "http://${AppStrings.deviceServerIP}/";
    emit(Connecting());
    try {
      Response response = await get(Uri.parse(baseUrl!));
      if (response.body == "Connected") {
        emit(Connected(baseUrl!));
      }
    } catch (e) {
      emit(NotConnected("Connection failed!"));
      emit(Initial());
      await Future.delayed(const Duration(seconds: 2));
      await AppSettings.openAppSettingsPanel(AppSettingsPanelType.wifi);
    }
  }
}
