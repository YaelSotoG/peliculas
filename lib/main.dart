import 'package:flutter/material.dart';

import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/peliculadetalle_page.dart';



void main() => runApp(PelisApp());


class PelisApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Películas',
      initialRoute: '/',
      routes: {
        '/' :  (BuildContext context)=> HomePage(),//se pone el (buildcontext context)por que la clase homepage te returna el context de la aplicacion
        'detalle':(BuildContext context)=>PeliculaDetalle(),
      },


      );
  }
}