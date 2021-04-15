import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rutas_curso/models/search_result.dart';

part 'busqueda_event.dart';

part 'busqueda_state.dart';

class BusquedaBloc extends Bloc<BusquedaEvent, BusquedaState> {
  BusquedaBloc() : super(BusquedaState());

  @override
  Stream<BusquedaState> mapEventToState(
    BusquedaEvent event,
  ) async* {
    if (event is OnActivarMarcadorManual) {
      yield state.copyWhit(seleccionManual: true);
    } else if (event is OnDesactivarMarcadorManual) {
      yield state.copyWhit(seleccionManual: false);
    } else if (event is OnAgregarHistorial) {
      final existe = state.historial
          .where((result) =>
              result.nombreDestino == event.searchResult.nombreDestino)
          .length;
      if (existe == 0) {
        final newHistorial = [...state.historial, event.searchResult];
        yield state.copyWhit(historial: newHistorial);
      }
    }
  }
}
