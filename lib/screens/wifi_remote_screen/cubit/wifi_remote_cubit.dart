import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
part 'wifi_remote_state.dart';

class WifiRemoteCubit extends Cubit<WifiRemoteState> {
  WifiRemoteCubit() : super(OffSignal());

  Future on(String baseUrl) async {
    emit(Loading());

    await get(Uri.parse('${baseUrl}on_signal'),
        headers: {"Accept": "plain/text"});
    emit(OnSignal());
  }

  Future off(String baseUrl) async {
    emit(Loading());
    await get(Uri.parse('${baseUrl}off_signal'),
        headers: {"Accept": "plain/text"});
    emit(OffSignal());
  }
}
