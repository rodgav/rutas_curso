part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapaListo extends MapaEvent {}

class OnNuevaUbicacion extends MapaEvent {
  final LatLng ubicacion;

  OnNuevaUbicacion(this.ubicacion);
}

class OnMarcarRecorrido extends MapaEvent {}

class OnSeguirUbicacion extends MapaEvent {}

class OnModioMapa extends MapaEvent {
  final LatLng centroMapa;

  OnModioMapa(this.centroMapa);
}

class OnCrearRutaInicioDestino extends MapaEvent {
  final List<LatLng> rutaCoordenadas;
  final double distancia;
  final double duration;
  final String nombreDestino;

  OnCrearRutaInicioDestino(
      this.rutaCoordenadas, this.distancia, this.duration, this.nombreDestino);
}
