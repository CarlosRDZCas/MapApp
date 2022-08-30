part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;
  final LatLng? lastKnownLocation;
  final List<LatLng> locationHistory;

  const LocationState(
      {this.followingUser = false, this.lastKnownLocation, locationHistory})
      : locationHistory = locationHistory ?? const [];

  @override
  List<Object?> get props =>
      [followingUser, lastKnownLocation, locationHistory];

      
  LocationState copyWith(
          {bool? followingUser,
          LatLng? lastKnownLocation,
          List<LatLng>? locationHistory}) =>
      LocationState(
          followingUser: followingUser ?? this.followingUser,
          lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
          locationHistory: locationHistory ?? this.locationHistory);
}
