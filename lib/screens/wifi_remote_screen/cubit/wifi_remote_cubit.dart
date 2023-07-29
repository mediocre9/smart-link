import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
part 'wifi_remote_state.dart';

class WifiRemoteCubit extends Cubit<WifiRemoteState> {
  WifiRemoteCubit() : super(OffSignal());

  Future<void> sendOnMessage(String baseUrl) async {
    emit(Loading());

    try {
      await http.get(
        Uri.parse('${baseUrl}on_signal'),
        headers: {"Accept": "plain/text"},
      );
    } on HttpException catch (e) {
      log(e.message);
    }
    emit(OnSignal());
  }

  Future<void> sendOffMessage(String baseUrl) async {
    emit(Loading());
    try {
      await http.get(
        Uri.parse('${baseUrl}off_signal'),
        headers: {"Accept": "plain/text"},
      );
    } on HttpException catch (e) {
      log(e.message);
    }
    emit(OffSignal());
  }
}
