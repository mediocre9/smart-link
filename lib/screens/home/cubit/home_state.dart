part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class Initial extends HomeState {}

class Scanning extends HomeState {}

class Result extends HomeState {
  final List<ScanResult> devices;

  const Result({required this.devices});
}
