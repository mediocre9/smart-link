import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
part 'wifi_home_state.dart';

class WifiHomeCubit extends Cubit<WifiHomeState> {
  WifiHomeCubit() : super(Initial());
  String? baseUrl;
  Future<void> hasConnectionBeenEstablished(String ip) async {
    baseUrl = "http://$ip/";
    emit(Connecting());
    try {
      Response response = await get(Uri.parse(baseUrl!));
      if (response.body == "Connected") {
        emit(Connected(baseUrl!));
      }
    } catch (e) {
      emit(NotConnected("Invalid IP address!"));
      emit(Initial());
    }
  }
}
