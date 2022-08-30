import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mapapp/blocs/blocs.dart';
import 'package:mapapp/views/views.dart';
import 'package:mapapp/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;
  @override
  void initState() {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state.lastKnownLocation == null) {
            return const Center(child: Text('Espere Por Favor'));
          }
          return SingleChildScrollView(
            child: Stack(
              children: [
                MapView(initialLocation: state.lastKnownLocation!),
              ],
            ),
          );
          //  Center(
          //   child: Text(
          //       '${state.lastKnownLocation!.latitude},${state.lastKnownLocation!.longitude}'),
          // );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          BtnCurrentLocation(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }
}
