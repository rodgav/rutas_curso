part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaListo;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;
  final LatLng? ubicacionCentral;

  //polylines

  final Map<String, Polyline> polilynes;

  MapaState(
      {this.mapaListo = false,
      this.dibujarRecorrido = false,
      this.seguirUbicacion = false,
      this.ubicacionCentral,
      Map<String, Polyline>? polilynes})
      : this.polilynes = polilynes ?? Map();

  MapaState copyWhit(
          {bool? mapaListo,
          bool? dibujarRecorrido,
          bool? seguirUbicacion,
          LatLng? ubicacionCentral,
          Map<String, Polyline>? polilynes}) =>
      MapaState(
          mapaListo: mapaListo ?? this.mapaListo,
          dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
          seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
          ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
          polilynes: polilynes ?? this.polilynes);
}
