import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:rutas_curso/bloc/busqueda/busqueda_bloc.dart';
import 'package:rutas_curso/models/search_result.dart';
import 'package:rutas_curso/search/search_destination.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        final resultado =
            await showSearch(context: context, delegate: SearchDestination());
        this._retornoBusqueda(context, resultado!);
      },
    );
  }

  _retornoBusqueda(BuildContext context, SearchResult result) {
    if (result.cancelo) return;
    if (result.manual!) {
      context.read<BusquedaBloc>().add(OnActivarMarcadorManual());
      return;
    } else {
      context.read<BusquedaBloc>().add(OnDesactivarMarcadorManual());
    }
  }
}
