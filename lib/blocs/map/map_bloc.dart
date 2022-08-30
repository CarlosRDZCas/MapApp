import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapapp/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  GoogleMapController? _mapController;

  MapBloc() : super(const MapState()) {
    on<OnMapInitializedEvent>(_onMapInit);
  }

  void _onMapInit(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.mapController;
    _mapController!.setMapStyle(uberMapTheme);
    emit(state.copyWith(isMapInitialized: true));
  }

  void moveCamera(LatLng newLocation) {
    CameraUpdate cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }
}
