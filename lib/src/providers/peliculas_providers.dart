import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelis_models.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider{
  String _apikey='80e8b2008946b6dd66f6e042fa51409d';
  String _url='api.themoviedb.org';
  String _language='es-ES';

  int _popularespage=0;
  bool _cargando=false;
  List<Pelicula> _populares=new List();
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast/*lo pueden ver muchas personas si no solo lo ve una persona*/();//se abre el stream curso 109
  
  Function (List<Pelicula>)get popularesSink => _popularesStreamController.sink.add;//introducir datos
  Stream <List<Pelicula>> get popularesStream => _popularesStreamController.stream;// escuchar o transmitir datos

  void disposeStreams(){
    _popularesStreamController?.close();
  }  //cada que se crea un stream se debe cerrar

  Future<List<Pelicula>> _procesarRespuesta(Uri url)async{
    
    final resp = await http.get(url);//llama al link y recibe el api
    final decodeData= json.decode(resp.body);//guarda el cuerpo del api decodedata
   // print(decodeData['results']);
    final peliculas= new Peliculas.fromJsonList(decodeData['results']);//guarda los resultados en un nuevo objeto 
    //print(peliculas.items[2].title);

    return peliculas.items;
  }



  Future<List<Pelicula>> getEnCines() async {//metodo
    final url= Uri.https(_url, '3/movie/now_playing',{// para que te haga el link de la pagina web
      ///// el mapa del jquery es opcional
      'api_key':_apikey,
      'language':_language,

    });

    return await _procesarRespuesta(url);

   }


   Future<List<Pelicula>> getPopular() async {
     if (_cargando)return[];//para que solo cargue una vez que llegue al final y no cargue por cada pixel que mueva
     _cargando=true;
     _popularespage++;
     final url=Uri.https(_url, '3/movie/popular',{
       'api_key': _apikey,
       'language': _language,
       'page'    :_popularespage.toString(),
     });
     final resp= await _procesarRespuesta(url);
     _populares.addAll(resp);
     popularesSink(_populares);
     _cargando=false;
     return resp;
   }

  Future<List<Actor>> getCast(String peliId)async{
    final url=Uri.https(_url, '3/movie/$peliId/credits',{
      'api_key':_apikey,
      'language':_language
    });
    final resp=await http.get(url);
    final decodedData=json.decode(resp.body);
    final cast=new Cast.fromJsonList(decodedData['cast']);
    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {//metodo
    final url= Uri.https(_url, '3/search/movie',{// para que te haga el link de la pagina web
      ///// el mapa del jquery es opcional
      'api_key':_apikey,
      'language':_language,
      'query':query,

    });

    return await _procesarRespuesta(url);

   }
}