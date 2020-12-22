import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelis_models.dart';
import 'package:peliculas/src/pages/peliculadetalle_page.dart';

class Cardswiper extends StatelessWidget {
  
  final List<Pelicula> pelis;
  
  Cardswiper({@required this.pelis});//constructor, el @required es para que si no ponen el total de peliculas no regresa nada asi evitando errores

  @override
  Widget build(BuildContext context) {


    final _tampant= MediaQuery.of(context).size;//el mediaquery me indica el tamaño de la pantalla
    


    return Container(
      padding: EdgeInsets.only(top:10.0),//separa de la parte de arriba 
    //  width: double.infinity,//que ocupe todo el ancho disponible
    //  height: 300.0,
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _tampant.width*0.7,
        itemHeight: _tampant.height*0.5,
        itemBuilder: (BuildContext context,int index){

          pelis[index].dobleId='${pelis[index].id}-tarjeta';
          //para evitar error con las peliculas que estan en populares y en cartelera secambia el id agregandole el nombre de tarjeta

          return Hero(
              tag: pelis[index].dobleId,//se manda aqui al modelo de peliculas
                      child: ClipRRect(//pone los bordes redondeados
             borderRadius:BorderRadius.circular(20.0),
             child: GestureDetector(
                child: FadeInImage(
                 image: NetworkImage(pelis[index].getPosterImg()),
                 placeholder:AssetImage('assets/loading.gif'),
                 fit:BoxFit.cover,
               ),
               onTap:(){
                 Navigator.pushNamed(context, 'detalle',arguments: pelis[index]);
               },
             ),
             //child:Image.network("http://via.placeholder.com/350x150",
            //fit: BoxFit.cover,//hace que se ajuste a la pantalla
         // ),
            ),
          );
        },
        itemCount: pelis.length,
        //pagination: new SwiperPagination(),// los 3 puntitos de abajo
       // control: new SwiperControl(),//las flechas de los lados
    ), 
    );
  }
}