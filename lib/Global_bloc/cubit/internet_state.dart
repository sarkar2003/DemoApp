part of 'internet_cubit.dart';

enum Status { connected, disconnected }

@immutable
abstract class InternetState {}

final class InternetInitial extends InternetState {}

final class InternetConnected extends InternetState {
  final Status status;
  InternetConnected({required this.status});
}

final class InternetDisconnected extends InternetState {}
