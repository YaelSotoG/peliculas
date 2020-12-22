import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelis_models.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';

class Moviehorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientepag;

  Moviehorizontal({@required this.peliculas, @required this.siguientepag});//constructor pero con atributos 

  final _pagecontroller= new PageController(
          initialPage:1,
          viewportFraction:0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize= MediaQuery.of(context).size;

    _pagecontroller.addListener(() {
      if(_pagecontroller.position.pixels >=_pagecontroller.position.maxScrollExtent-200){
        siguientepag();
      } 
    });    

    return Container(
      height: _screenSize.height * .33,//tamaño de la pantalla
      child: PageView.builder(// el page view crea todos los widgets y pageview.builder solo cuando se necesita en conclusion: optimizacion
        pageSnapping:false,// como rota si se detiene al soltar la pantalla o se sigue
        controller: _pagecontroller, 
        itemCount: peliculas.length,
        itemBuilder: (context, i)=> _tarjeta(context, peliculas[i]),
        
        /*PageController(//indica como se ve
          initialPage:1,
          viewportFraction:0.3,//.3 de la pantalla y se ve.1 de la sig pelicula
        ),*/
        //children: _tarjetas(context),
      ),//deslizar widgets y paginas
    );
  }


  Widget _tarjeta(BuildContext context, Pelicula pelicula){
    
    pelicula.dobleId='${pelicula.id}-poster';
    
    final tarj= Container(
        margin:EdgeInsets.only(right:15.0),
        child:Column(
          children: <Widget>[
            Hero(
                tag: pelicula.dobleId,
                child: ClipRRect(//para que se redonde
                borderRadius:BorderRadius.circular(20.0) ,
                  child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/loading.gif'),//imagen mienstras carga
                  fit: BoxFit.cover,//cubre toda la pantalla
                  height: 160.0,
                
                ),
              ),
            ),
            SizedBox(height: 5.0),//separa el texto de la imagen
            Text(pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption)
          ],
        ),

      );
      return GestureDetector(
        child: tarj,
          onTap: (){
            Navigator.pushNamed(context, 'detalle',arguments: pelicula);
          },
      );
  }

  List<Widget> _tarjetas(BuildContext context){

    return peliculas.map((pelicula){
      return Container(
        margin:EdgeInsets.only(right:15.0),
        child:Column(
          children: <Widget>[
            ClipRRect(//para que se redonde
              borderRadius:BorderRadius.circular(20.0) ,
                child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/loading.gif'),//imagen mienstras carga
                fit: BoxFit.cover,//cubre toda la pantalla
                height: 160.0,
              
              ),
            ),
            SizedBox(height: 5.0),//separa el texto de la imagen
            Text(pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption)
          ],
        ),

      );

    }).toList();//.tolist para convertirlo en lista


  }
}
