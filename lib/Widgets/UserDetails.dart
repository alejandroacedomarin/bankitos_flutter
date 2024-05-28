import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Widgets/ProfileInfo.dart';
import 'package:bankitos_flutter/Widgets/Stars.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Details'),
          backgroundColor: Colors.orange,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Sección de información del perfil
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: StarRating(rating: user.user_rating),
                  ),
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: user.photo.isEmpty
                        ? AssetImage('assets/userdefec.png')
                            as ImageProvider<Object>?
                        : NetworkImage(
                            user.photo), // URL de la foto si está disponible
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    '${user.first_name} ${user.last_name}',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  ExpansionTile(
                    title: Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          user.description,
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Divider(), // Línea separadora
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Information',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Bloque de Profile Information
                  ProfileInformation(
                    label: 'ID',
                    value: user.id,
                  ),
                  ProfileInformation(
                    label: 'First Name',
                    value: user.first_name,
                  ),
                  ProfileInformation(
                      label: 'Middle Name', value: user.middle_name),
                  ProfileInformation(label: 'Last Name', value: user.last_name),
                ],
              ),
            ],
          ),
        ));
  }
}
