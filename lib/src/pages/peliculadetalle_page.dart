import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelis_models.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula= ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body:CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0,),
                _posterTitulo(context, pelicula),
                _descripcion(pelicula),
                _crearCasting(pelicula),
              ]
            ),
          ),
        ],
      ),
      );
  }

  Widget _crearAppbar(Pelicula pelicula){
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.red,
     expandedHeight: 200.0,
      // hace que el appbar se baje 
      floating: false,
      //hace que se pueda mover el appbar
      pinned: false,
      // se mantengan visibles las cosas cuando se hace el scroll
     flexibleSpace: FlexibleSpaceBar(//hace que lo que este adentro se mueva con el appbar
        centerTitle:true,
        title:Text(
          pelicula.title,
          style:TextStyle(color: Colors.white,fontSize:16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),//hace que no funcine
          fit: BoxFit.cover,//que cubra el appbar
        ),
      ),
    );//sliver hacen cosas bonitas con el scroll
  }
  
  Widget _posterTitulo(BuildContext context, Pelicula pelicula){
    return Container(
      padding:EdgeInsets.symmetric(horizontal:15),
      child: Row(
        children: <Widget>[
          Hero(
              tag:pelicula.dobleId ,
              child: ClipRRect(//para redondear
                borderRadius:BorderRadius.circular(20.0),
                child: Image(
                  image:NetworkImage(pelicula.getPosterImg()),
                  height: 150.0,
                ),
            ),
          ),
          SizedBox(width:20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle,  style: Theme.of(context).textTheme.subtitle1,overflow: TextOverflow.ellipsis),
                Row(children: <Widget>[
                  Icon(Icons.star_border),
                  Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle1)
                  ],
                  )
              ],
            ),
            ),
        ],
      ),

    );
  }

  Widget _descripcion(Pelicula pelicula){
    return Container(
      padding:EdgeInsets.symmetric(horizontal:10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
        ),
    );
  }

 Widget _crearCasting(Pelicula pelicula){
   final peliprovider= new PeliculasProvider();
   return FutureBuilder(
     future: peliprovider.getCast(pelicula.id.toString()) ,
     builder: (context, AsyncSnapshot <List>snapshot){
        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
        }else{
          return Center(child:CircularProgressIndicator());
        }
     },
     );
 }
     Widget _crearActoresPageView(List<Actor>actores){

       return SizedBox(
         height:200.0,
         child:PageView.builder(
           pageSnapping: false,
           itemCount: actores.length,
           controller: PageController(
             viewportFraction:.3,
             initialPage:1,
           ),
           itemBuilder:(context, i)=>_actortarg(actores[i])
           ),
       );
       

     }
     Widget _actortarg(Actor actor){
       return Container(
         child:Column(
           children: <Widget>[
             ClipRRect(
               borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                 image: NetworkImage(actor.getFoto()),
                 placeholder: AssetImage('assets/no-image.jpg') ,
                 height: 150.0,
                 fit: BoxFit.cover,
               ),
             ),
             Text(
               actor.name,
               overflow: TextOverflow.ellipsis,
               )
           ],
           ),
       );
     }
 
}