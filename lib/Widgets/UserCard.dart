import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Widgets/UserDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserWidget extends StatelessWidget {
  final User? user;

  const UserWidget({Key? key, required this.user}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return Card(
      child: ListTile(
        tileColor: Colors.transparent ,
        leading: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: user!.photo.isEmpty
                      ? AssetImage('assets/userdefec.png') as ImageProvider<Object>?
                      : NetworkImage(user!.photo), // URL de la foto si está disponible
        ),
        title: Text(user!.first_name),
        subtitle: Text(user!.last_name),
        onTap: () {
          Get.to(() => UserDetails(user!));
        },
      ),
    );
  }
}