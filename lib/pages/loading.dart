import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rutas_curso/pages/acceso_gps.dart';
import 'package:rutas_curso/pages/mapa.dart';
import 'package:rutas_curso/helpers/helpers.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('state $state');
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacement(
            context, navegarMapaFadeIn(context, MapaPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: this.checkGpsLocation(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Text(snapshot.data),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }),
    );
  }

  Future checkGpsLocation(BuildContext context) async {
    //todo:permiso gps
    final permisoGPS = await Permission.location.isGranted;
    //todo: GPS activo
    final gpsActivo = await Geolocator.isLocationServiceEnabled();
    if (permisoGPS && gpsActivo) {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, MapaPage()));
    } else if (!permisoGPS) {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, AccesoGpsPage()));
      return 'Es necesario el permiso de GPS';
    } else {
      return 'Active el GPS';
    }
  }
}
