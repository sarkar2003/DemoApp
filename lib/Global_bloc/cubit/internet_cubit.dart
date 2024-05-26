import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final InternetConnectivity internetConnectivity;
  late StreamSubscription connectivitystreamSubscription;

  InternetCubit({required this.internetConnectivity})
      : super(InternetInitial()) {
    connectivitystreamSubscription =
        internetConnectivity.observeInternetConnection.listen((bool status) {
      if (status) {
        connected(Status.connected);
      } else {
        disconnected();
      }
    });
  }

  void connected(Status status) => emit(InternetConnected(status: status));
  void disconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    connectivitystreamSubscription.cancel();
    return super.close();
  }
}
