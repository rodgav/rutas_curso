import 'package:flutter/material.dart';
import 'package:rutas_curso/pages/acceso_gps.dart';
import 'package:rutas_curso/pages/mapa.dart';
import 'package:rutas_curso/helpers/helpers.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: this.checkGpsLocation(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            );
          }),
    );
  }

  Future checkGpsLocation(BuildContext context) async{
    //todo:permiso gps
    //todo: GPS activo
   await Future.delayed(Duration(milliseconds: 2000),(){
      Navigator.pushReplacement(context, navegarMapaFadeIn(context, AccesoGpsPage()));
      //Navigator.pushReplacement(context, navegarMapaFadeIn(context, MapaPage()));
    });
  }
}
