import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';


class HomePage extends StatelessWidget {

  final peliculasprovider= new PeliculasProvider();
  @override
  Widget build(BuildContext context) {
    peliculasprovider.getPopular();
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en cines'),
        centerTitle: false,//quita el titulo del centro
        backgroundColor: Colors.indigoAccent,//no se pone color() por que ya por defecto es un color :v
        actions: <Widget>[//recuerda ver sus ayudas, el actions solo returna una lista de widgets, el floatinactionbotton es el boton asi random
          IconButton(//returna un boton icono
            icon: Icon(Icons.search), 
            onPressed: (){
              showSearch(
                context: context, 
                delegate: Datasearch(),
                //query: 'hola',//hace que al abrir la busqueda escriba un hola automaticamente
                );
            },
            )
        ],

      ),
      body:Container(
        child:Column(//una columna como en matlab
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),//es un metodo
          ],
        ),
      ),
      //SafeArea(//cuando se usan celulares con la camara enfrente de la pantalla, (como el de mi amor) guarda el ese espacio
      //  child: Text('data'),
      //),
      
    );
  
  }

  Widget _swiperTarjetas(){
   return FutureBuilder(
     future: peliculasprovider.getEnCines(),
    // initialData: InitialData,
     builder: (BuildContext context, AsyncSnapshot <List> snapshot){
       
       if(snapshot.hasData){return Cardswiper(pelis: snapshot.data);
       } else{
         return Container(
           height: 400.0,
           child: Center(
             child: CircularProgressIndicator()
             )
             );
       }
     },

     );
  // peliculasprovider.getEnCines();
   //return Cardswiper(pelis: [1,2,3,4,5,6,7]);
  }
  Widget _footer(BuildContext context){ 
         return Container(
             width: double.infinity,// infinity para que agarre todo el espacio
             child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
                 Container(
                   padding: EdgeInsets.only(left:20.0),//mueve el populares 
                   child: Text('populares', style:Theme.of(context).textTheme.subtitle1)),// para configurar el tema, se usa para que los titulos tengan un tema en particular
           //se encuentra en el material app
                  SizedBox(height: 5.0,),


                  
                  StreamBuilder(
                    stream:peliculasprovider.popularesStream,
                    builder: (BuildContext context, AsyncSnapshot<List> snapshot){
                      //snapshot.data?.forEach((p) => print(p.litle));
                      // print(snapshot.data);
                      if (snapshot.hasData){
                        return Moviehorizontal(
                          peliculas:snapshot.data,
                          siguientepag: peliculasprovider.getPopular,/*para que recargue las populares*/);
                      }else{
                        return CircularProgressIndicator();
                      }
                    //return Container();
                        },),
              ],

       ),
       );}

   

}