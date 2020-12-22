import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelis_models.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';


class Datasearch extends SearchDelegate{

  String seleccion='';
  final peliculasProvider= new PeliculasProvider();
   //final peliculas=['acuaman','protoman','zero','megaman'];
   //final peliculasrecient=['spiderman','capitan america','ironman','megaman'];


  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions acciones de nuestro appbar(limpiar o cancelar)
    return [
      IconButton(
      icon: Icon(Icons.clear),
      onPressed: (){
        query='';//hace que se ponga vacio lo que escribamos
      },

    ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeadingo icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(//icono animado
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,//tiempo en que se anima el icono (0 a 1)
      ), 
      onPressed: (){
        close(context, null);//cierra la ventana actual

      });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults build o crea resultados
    return Center(
      child:Container(),
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty){// si el texto esta vacio no manda nada
      return Container();
    }
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot <List<Pelicula>> snapshot) {
        if(snapshot.hasData){
          final peliculas=snapshot.data;
          return ListView(
            children:peliculas.map((peliculas) {
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/loading.gif'), 
                  image: NetworkImage(peliculas.getPosterImg()),
                  width: 50.0,
                  fit: BoxFit.contain,
                  ),
                title: Text(peliculas.title),
                subtitle: Text(peliculas.originalTitle),
                onTap: (){
                  close(context, null);
                  peliculas.dobleId='';
                  Navigator.pushNamed(context, 'detalle', arguments: peliculas);
                },
              );
            }).toList()
          );
        }else{
        return Center(
          child: CircularProgressIndicator(),
        ) ;
      }}
    );
  
  }

//@override
  //Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions son las sugerencias que aparecen cuando la persona escribe
    
   // final listsugerida= (query.isEmpty) ? peliculasrecient//si el query esta vacio mostrara las peliculas recientes
                                       // : peliculas.where(// si no la lista donde la pelicula(p) donde las letras (.tolower hace que lea igual minusculas y mayusculas), inician con. startswith, las mismas letras del query
                                        //  (p) => p.toLowerCase().startsWith(query.toLowerCase()
                                        //  )).toList();//ponlo en lista
   // return ListView.builder(
     // itemCount:listsugerida.length,//cuenta las peliculas
     // itemBuilder: (context,i){
       // return ListTile(//returna un listado
        //  leading: Icon(Icons.movie),
        //  title:Text(listsugerida[i]),
        //  onTap: (){
         //   seleccion=listsugerida[i];
        //// },
     //   );

     // },
     
    //  );
 // }

      
}