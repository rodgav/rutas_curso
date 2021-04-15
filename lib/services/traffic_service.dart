import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_curso/helpers/debouncer.dart';
import 'package:rutas_curso/models/reverse_query_response.dart';
import 'package:rutas_curso/models/traffic_response.dart';
import 'package:rutas_curso/models/search_response.dart';

class TrafficServices {
  TrafficServices._privateConstructor();

  static final TrafficServices _instance =
      TrafficServices._privateConstructor();

  factory TrafficServices() {
    return _instance;
  }

  final _dio = Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));

  final _sugerenciasStreamController =
      StreamController<SearchResponse>.broadcast();

  Stream<SearchResponse> get sugerenciasStream =>
      this._sugerenciasStreamController.stream;
  final _baseUrlDir = 'https://api.mapbox.com/directions/v5';
  final _baseUrlGeo = 'https://api.mapbox.com/geocoding/v5';
  final _apiKey =
      'pk.eyJ1IjoicnNnbSIsImEiOiJja25oc2dhbDcwb2dyMm9wYzVrZDY1emNhIn0.2q72d__vUe_rdq-fmeEqxQ';

  Future<TrafficResponse> getCoordsInicioyFin(
      LatLng inicio, LatLng destino) async {
    final coordString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '$_baseUrlDir/mapbox/driving/$coordString';

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

  Future<SearchResponse> getResultadosPorQuery(
      String busqueda, LatLng proximidad) async {
    try {
      final url = '$_baseUrlGeo/mapbox.places/$busqueda.json';
      final respuesta = await _dio.get(url, queryParameters: {
        'access_token': this._apiKey,
        'autocomplete': 'true',
        'proximity': '${proximidad.longitude},${proximidad.latitude}',
        'language': 'es'
      });
      final data = searchResponseFromJson(respuesta.data);
      return data;
    } catch (e) {
      return SearchResponse(features: []);
    }
  }

  void getSugerenciasPorQuery(String busqueda, LatLng proximidad) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await this.getResultadosPorQuery(value, proximidad);
      this._sugerenciasStreamController.add(resultados);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  Future<ReverseQueyResponse> getCoordsInfo(LatLng destinoCoords) async {
    final url =
        '$_baseUrlGeo/mapbox.places/${destinoCoords.longitude},${destinoCoords.latitude}.json';
    final respuesta = await _dio.get(url,
        queryParameters: {'access_token': this._apiKey, 'language': 'es'});
    final data = reverseQueyResponseFromJson(respuesta.data);
    return data;
  }

  void dispose() {
    _sugerenciasStreamController.close();
  }
}
