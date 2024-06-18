import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Widgets/UserDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ReviewWidget extends StatelessWidget {
  final Review rev;

  const ReviewWidget({Key? key, required this.rev}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return Card(
      child: ListTile(
        tileColor: Colors.transparent ,
        
        title: Text(rev.title),
        subtitle: Text(rev.content),
        onTap: () {
          //Get.to(() => UserDetails(user!));
        },
      ),
    );
  }
}