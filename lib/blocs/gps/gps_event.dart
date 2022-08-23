part of 'gps_bloc.dart';

abstract class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object> get props => [];
}

class GpsAndPermissionEvent extends GpsEvent {
  final bool isGPSEnable;
  final bool isGPSPermissionGranted;

  const GpsAndPermissionEvent({
    required this.isGPSEnable,
    required this.isGPSPermissionGranted,
  });
}
