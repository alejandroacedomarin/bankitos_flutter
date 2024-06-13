import 'package:bankitos_flutter/Screens/Places/GetPlaces.dart';
import 'package:bankitos_flutter/Screens/MainPage/SearchEngine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bankitos_flutter/Screens/Users/UserDetails.dart';
import 'package:bankitos_flutter/Screens/Mapa/Mapa.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          overlayColor:  MaterialStateProperty.all(Colors.orange),
          indicatorColor: Colors.orange,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Iconsax.search_normal), label: 'Search'),
            NavigationDestination(
                icon: Icon(Iconsax.house), label: 'Mis Places'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    GoogleMapsScreen(),
    SearchScreen(),
    PlaceListPage(),
    UserProfileScreen()
  ];
}
