import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_curso/bloc/mapa/mapa_bloc.dart';
import 'package:rutas_curso/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:rutas_curso/widgets/btn_float.dart';
import 'package:rutas_curso/widgets/marcador_manual.dart';
import 'package:rutas_curso/widgets/searchBar.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  void initState() {
    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    context.read<MiUbicacionBloc>().cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapaBloc = context.read<MapaBloc>();
    final miUbicacionBloc = context.read<MiUbicacionBloc>();
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
                  builder: (_, state) => crearMapa(state, mapaBloc)),
              Positioned(top: 10, child: SearchBar()),
              MarcadorManual()
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<MapaBloc, MapaState>(
            builder: (_, state) =>
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BtnFloat(
                      iconData: Icons.my_location,
                      maxRadius: 25,
                      onPressed: () {
                        final destino = miUbicacionBloc.state.ubicacion;
                        mapaBloc.moverCamara(destino!);
                      },
                    ),
                    BtnFloat(
                      iconData: Icons.more_horiz,
                      maxRadius: 25,
                      onPressed: () {
                        mapaBloc.add(OnMarcarRecorrido());
                      },
                    ),
                    BtnFloat(
                      iconData: state.seguirUbicacion
                          ? Icons.directions_run
                          : Icons.accessibility_new,
                      maxRadius: 25,
                      onPressed: () {
                        mapaBloc.add(OnSeguirUbicacion());
                      },
                    ),
                  ],
                )));
  }

  Widget crearMapa(MiUbicacionState state, MapaBloc mapaBloc) {
    if (!state.existeUbicacion) return Center(child: Text('Ubicando...'));
    final cameraPosition = CameraPosition(target: state.ubicacion!, zoom: 15);


    return BlocBuilder<MapaBloc, MapaState>(
      builder: (_, __) {
        return GoogleMap(
          initialCameraPosition: cameraPosition,
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: mapaBloc.initMapa,
          polylines: mapaBloc.state.polilynes.values.toSet(),
          onCameraMove: (cameraPosition) {
            mapaBloc.add(OnModioMapa(cameraPosition.target));
          },
        );
      },
    );
  }
}
