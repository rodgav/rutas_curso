import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResult {
  final bool cancelo;
  final bool? manual;
  final LatLng? position;
  final String? nombreDestino;
  final String? description;

  SearchResult(
      {required this.cancelo,
      this.manual,
      this.position,
      this.nombreDestino,
      this.description});
}
