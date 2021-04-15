import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_curso/models/traffic_response.dart';

class TrafficServices {
  TrafficServices._privateConstructor();

  static final TrafficServices _instance =
      TrafficServices._privateConstructor();

  factory TrafficServices() {
    return _instance;
  }

  final _dio = Dio();
  final _baseUrl = 'https://api.mapbox.com/directions/v5';
  final _apiKey =
      'pk.eyJ1IjoicnNnbSIsImEiOiJja25oc2dhbDcwb2dyMm9wYzVrZDY1emNhIn0.2q72d__vUe_rdq-fmeEqxQ';

  Future<TrafficResponse> getCoordsInicioyFin(LatLng inicio, LatLng destino) async {
    final coordString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '$_baseUrl/mapbox/driving/$coordString';

    final respuesta = await _dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this._apiKey,
      'language': 'es'
    });
    final data = TrafficResponse.fromJson(respuesta.data);
    return data;
  }
}
