import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;
  GpsBloc()
      : super(
            const GpsState(isGPSEnable: false, isGPSPermissionGranted: false)) {
    on<GpsAndPermissionEvent>((event, emit) => emit(state.copyWith(
        isGPSEnable: event.isGPSEnable,
        isGPSPermissionGranted: event.isGPSPermissionGranted)));
    _init();
  }

  Future<void> _init() async {
    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _checkAccessGranted(),
    ]);
    add(GpsAndPermissionEvent(
        isGPSEnable: gpsInitStatus[0],
        isGPSPermissionGranted: gpsInitStatus[1]));
  }

  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();
    gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
      add(GpsAndPermissionEvent(
          isGPSEnable: isEnabled,
          isGPSPermissionGranted: state.isGPSPermissionGranted));
    });
    return isEnable;
  }

  Future<bool> _checkAccessGranted() async {
    final isGranted = Permission.location.isGranted;
    return isGranted;
  }

  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();
    return super.close();
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.granted:
        GpsAndPermissionEvent(
            isGPSEnable: state.isGPSEnable, isGPSPermissionGranted: true);
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        GpsAndPermissionEvent(
            isGPSEnable: state.isGPSEnable, isGPSPermissionGranted: false);
        openAppSettings();
    }
  }
}
