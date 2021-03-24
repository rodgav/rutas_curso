import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutas_curso/pages/acceso_gps.dart';
import 'package:rutas_curso/pages/loading.dart';
import 'package:rutas_curso/pages/mapa.dart';
import 'package:rutas_curso/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => MiUbicacionBloc())],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => LoadingPage(),
          'acceso_gps': (_) => AccesoGpsPage(),
          'mapa': (_) => MapaPage(),
        },
      ),
    );
  }
}
