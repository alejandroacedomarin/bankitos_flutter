// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:convert';
import 'package:bankitos_flutter/Widgets/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Screens/CreatePlace.dart';
import 'package:bankitos_flutter/Widgets/button_sign_in.dart';
import 'package:bankitos_flutter/Widgets/post.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:dio/dio.dart' ;
import 'package:bankitos_flutter/Services/UserService.dart';

late UserService userService;


class PlaceListPage extends StatefulWidget {
    PlaceListPage({Key? key}) : super(key: key);

  @override
  _PlaceListPage createState() => _PlaceListPage();
}

class _PlaceListPage extends State<PlaceListPage> {
  late List<Place> lista_users;

  bool isLoading = true; // Nuevo estado para indicar si se están cargando los datos

  @override
  void initState() {
    super.initState();
    userService = UserService();  
    String id = userService.getUserId();
    print('ID: $id');
    getData(id);
  }

  void getData(id) async {
    print('getData');
    try {
      print('ID: $id');
      lista_users = await userService.getData(id);
      setState(() {
        isLoading = false; // Cambiar el estado de carga cuando los datos están disponibles
      });
    } catch (error) {
      Get.snackbar(
        'Error',
        'No se han podido obtener los datos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al comunicarse con el backend: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Muestra un indicador de carga mientras se cargan los datos
      return Center(child: CircularProgressIndicator());
    } else {
      // Muestra la lista de usuarios cuando los datos están disponibles
      return Scaffold(
        appBar: AppBar(
          title: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('My Places'),
              SizedBox(width: 60)
            ],
          ),
        ),          
        backgroundColor: Colors.orange,      
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.turn_left,
                color: Colors.black,
              ),
              onPressed: () {
                Get.to(NavigationMenu());
              },
            ),
          ),
        ),
       body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: lista_users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: PostWidget(place: lista_users[index]),
                    );
                  },
                ),
              ),
              SignInButton(
                onPressed: (){ 
                  Get.to(CreatePostScreen());
                },
                text: '¡Create a Place!'
              ),
            ],
          ),
        ),
      );
    }
  }
}

  