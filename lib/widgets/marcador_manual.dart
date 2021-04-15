import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_curso/bloc/busqueda/busqueda_bloc.dart';
import 'package:rutas_curso/bloc/mapa/mapa_bloc.dart';
import 'package:rutas_curso/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:rutas_curso/helpers/calculando_alerta.dart';
import 'package:rutas_curso/services/traffic_service.dart';
import 'package:rutas_curso/widgets/btn_float.dart';
import 'package:rutas_curso/helpers/polyline_base.dart' as Poly;

class MarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(builder: (_, state) {
      if (state.seleccionManual) return _BuildMarcadorManual();
      return Container();
    });
  }
}

class _BuildMarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
            top: 10,
            left: 10,
            child: FadeInLeft(
              duration: Duration(milliseconds: 150),
              child: BtnFloat(
                  iconData: Icons.arrow_back,
                  maxRadius: 20,
                  onPressed: () => context
                      .read<BusquedaBloc>()
                      .add(OnDesactivarMarcadorManual())),
            )),
        Center(
          child: Transform.translate(
            offset: Offset(0, -12),
            child: BounceInDown(
              from: 200,
              child: Icon(
                Icons.location_on,
                size: 50,
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 10,
            left: 40,
            child: MaterialButton(
                color: Colors.black,
                shape: StadiumBorder(),
                minWidth: size.width - 120,
                elevation: 0,
                splashColor: Colors.transparent,
                child: Text(
                  'Confirmar destino',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _calcularDestino(context)))
      ],
    );
  }

  void _calcularDestino(BuildContext context) async {
    calculandoAlerta(context);
    final trafficServices = TrafficServices();
    final mapaBloc = context.read<MapaBloc>();
    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = mapaBloc.state.ubicacionCentral;

    final reverseQueryResponse = await trafficServices.getCoordsInfo(destino!);

    final trafficResponse =
        await trafficServices.getCoordsInicioyFin(inicio!, destino);

    final geometry = trafficResponse.routes![0].geometry;
    final duration = trafficResponse.routes![0].duration;
    final distance = trafficResponse.routes![0].distance;
    final nombreDestino = reverseQueryResponse.features![0].textEs;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final List<LatLng> rutaCoords =
        points!.map((point) => LatLng(point[0], point[1])).toList();
    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCoords, distance!, duration!, nombreDestino!));

    Navigator.of(context).pop();
    context.read<BusquedaBloc>().add(OnDesactivarMarcadorManual());
  }
}
