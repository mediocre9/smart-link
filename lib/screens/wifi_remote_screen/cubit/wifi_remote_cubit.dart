import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

enum WifiRemoteState {
  loading,
  onSignal,
  offSignal,
}

class WifiRemoteCubit extends Cubit<WifiRemoteState> {
  WifiRemoteCubit() : super(WifiRemoteState.offSignal);

  Future<void> sendOnMessage(String baseUrl) async {
    emit(WifiRemoteState.loading);

    try {
      await http.get(
        Uri.parse('$baseUrl/on_signal'),
        headers: {"Accept": "plain/text"},
      );
      emit(WifiRemoteState.onSignal);
    } on HttpException catch (e) {
      log(e.message);
    }
  }

  Future<void> sendOffMessage(String baseUrl) async {
    emit(WifiRemoteState.loading);
    try {
      await http.get(
        Uri.parse('$baseUrl/off_signal'),
        headers: {"Accept": "plain/text"},
      );
      emit(WifiRemoteState.offSignal);
    } on HttpException catch (e) {
      log(e.message);
    }
  }
}
