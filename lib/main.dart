import 'package:flutter/material.dart';
import 'package:rutas_curso/pages/acceso_gps.dart';
import 'package:rutas_curso/pages/loading.dart';
import 'package:rutas_curso/pages/mapa.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
