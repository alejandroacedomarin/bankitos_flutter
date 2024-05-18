import 'package:bankitos_flutter/Screens/MyPlacesList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bankitos_flutter/Screens/Profile.dart';
import 'package:bankitos_flutter/Screens/CreatePlace.dart';


class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});
  

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(

      bottomNavigationBar: Obx(() => NavigationBar(

        height: 80,

        elevation: 0,

        selectedIndex: controller.selectedIndex.value,

        onDestinationSelected: (index) => controller.selectedIndex.value = index,

        destinations: const [

          NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),

          NavigationDestination(icon: Icon(Iconsax.search_normal1), label: 'Search'),

          NavigationDestination(icon: Icon(Iconsax.house), label: 'Mis Places'),

          NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),

        ],

      ),), 

      body: Obx(() => controller.screens[controller.selectedIndex.value]),

    );
  }
}

class NavigationController extends GetxController{

  final Rx<int> selectedIndex = 0.obs;

  final screens = [Container(color: Colors.green),Container(color: Colors.orange), PlaceListPage(), UserProfileScreen()];

}