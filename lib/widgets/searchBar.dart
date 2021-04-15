import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_curso/bloc/busqueda/busqueda_bloc.dart';
import 'package:rutas_curso/bloc/mapa/mapa_bloc.dart';
import 'package:rutas_curso/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:rutas_curso/helpers/calculando_alerta.dart';
import 'package:rutas_curso/models/search_result.dart';
import 'package:rutas_curso/search/search_destination.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutas_curso/services/traffic_service.dart';
import 'package:rutas_curso/helpers/polyline_base.dart' as Poly;

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(builder: (_, state) {
      if (state.seleccionManual) return Container();
      return FadeInDown(
          duration: Duration(milliseconds: 300),
          child: _buildSearchBar(context));
    });
  }

  Widget _buildSearchBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, 5)),
              ]),
          child: Text(
            'Donde quieres ir',
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ),
      onTap: () async {
        final proximidad = context.read<MiUbicacionBloc>().state.ubicacion;
        final historial = context.read<BusquedaBloc>().state.historial;
        final resultado = await showSearch(
            context: context,
            delegate: SearchDestination(proximidad!, historial));
        this._retornoBusqueda(context, resultado!);
      },
    );
  }

  Future _retornoBusqueda(BuildContext context, SearchResult result) async {
    if (result.cancelo) return;
    if (result.manual!) {
      context.read<BusquedaBloc>().add(OnActivarMarcadorManual());
      return;
    }

    calculandoAlerta(context);
    TrafficServices trafficServices = TrafficServices();
    final mapaBloc = context.read<MapaBloc>();
    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = result.position;
    final drivingResponse =
        await trafficServices.getCoordsInicioyFin(inicio!, destino!);
    final geometry = drivingResponse.routes![0].geometry;
    final duration = drivingResponse.routes![0].duration;
    final distance = drivingResponse.routes![0].distance;
    final nombreDestino = result.nombreDestino;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final List<LatLng> rutaCoords =
        points!.map((point) => LatLng(point[0], point[1])).toList();
    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCoords, distance!, duration!, nombreDestino!));
    Navigator.of(context).pop();

    final busquedaBloc = context.read<BusquedaBloc>();
    busquedaBloc.add(OnAgregarHistorial(result));
  }
}
