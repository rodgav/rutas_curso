import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_curso/models/search_response.dart';
import 'package:rutas_curso/models/search_result.dart';
import 'package:rutas_curso/services/traffic_service.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TrafficServices _trafficServices;
  final LatLng proximidad;
  final List<SearchResult> historial;

  SearchDestination(this.proximidad, this.historial)
      : this.searchFieldLabel = 'Buscar...',
        this._trafficServices = TrafficServices();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => this.query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final searchResult = SearchResult(cancelo: true);
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => this.close(context, searchResult));
  }

  @override
  Widget buildResults(BuildContext context) {
    return this._construirResultadosSugerencias();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.isEmpty)
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Colocar ubicación manualmente'),
            onTap: () {
              this.close(context, SearchResult(cancelo: false, manual: true));
            },
          ),
          ...this
              .historial
              .map((result) => ListTile(
                    leading: Icon(Icons.history),
                    title: Text(result.nombreDestino!),
                    subtitle: Text(result.description!),
                    onTap: () {
                      this.close(context, result);
                    },
                  ))
              .toList()
        ],
      );

    return this._construirResultadosSugerencias();
  }

//.getResultadosPorQuery(this.query.trim(), proximidad)
  Widget _construirResultadosSugerencias() {
    if (this.query.isEmpty) return Container();
    this._trafficServices.getSugerenciasPorQuery(this.query.trim(), proximidad);
    return StreamBuilder(
        stream: this._trafficServices.sugerenciasStream,
        builder:
            (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final lugares = snapshot.data!.features;
          if (lugares!.isEmpty)
            return Center(
              child: ListTile(title: Text(('No hay resultados con $query'))),
            );
          return ListView.separated(
              itemBuilder: (_, i) {
                final lugar = lugares[i];

                return ListTile(
                  leading: Icon(Icons.place),
                  title: Text(lugar.textEs!),
                  subtitle: Text(lugar.placeNameEs!),
                  onTap: () {
                    this.close(
                        context,
                        SearchResult(
                            cancelo: false,
                            manual: false,
                            position:
                                LatLng(lugar.center![1], lugar.center![0]),
                            nombreDestino: lugar.textEs,
                            description: lugar.placeNameEs));
                  },
                );
              },
              separatorBuilder: (_, i) => Divider(),
              itemCount: lugares.length);
        });
  }
}
