import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Widgets/button_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:dio/dio.dart' ;
import 'dart:io';


class PlaceDetailsPage extends StatelessWidget {
  final Place place;
  

const PlaceDetailsPage(this.place, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${place.title}'),
            Text('Content: ${place.content}'),
            Text('Image: '),
            Image.network(place.photo),
            Text('ID del autor: ${place.authorId}'),
            Text('Dirección: ${place.address}'),
            Text('ID: ${place.id}'),
            SignInButton(
                onPressed: (){ 
                  //Get.to(UpdatePostScreen(place: place));
                },
                text: 'Actualiza este post!'
              ),
          ],
        ),
      ),
    );
  }
}