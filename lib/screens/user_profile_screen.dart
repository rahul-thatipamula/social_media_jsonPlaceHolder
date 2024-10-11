import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/models/app_data.dart';

class UserProfileScreen extends StatelessWidget {
  final int userId;
  final appDataController = Get.find<AppData>();

  UserProfileScreen({Key? key, required this.userId}) : super(key: key) {
    appDataController.loadUserById(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (appDataController.isUserLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = appDataController.user.value;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
        
                    child: Icon(Icons.person, size: 60)
                      
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    user.name.toString(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                customTile(Icons.person, 'Username', user.username.toString()),
                customTile(Icons.email, 'Email', user.email.toString()),
                customTile(Icons.phone, 'Phone', user.phone.toString()),
                customTile(Icons.web, 'Website', user.website.toString()),
                const SizedBox(height: 20),
                const Text('Address', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                customTile(Icons.location_on, 'Street', user.address!.street),
                customTile(Icons.location_city, 'Suite', user.address!.suite),
                customTile(Icons.location_city, 'City', user.address!.city),
                customTile(Icons.location_pin, 'Zipcode', user.address!.zipcode),
                const SizedBox(height: 10),
                const Text('Geo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                customTile(Icons.map, 'Latitude', user.address!.geo.lat),
                customTile(Icons.map, 'Longitude', user.address!.geo.lng),
                const SizedBox(height: 20),
                const Text('Company', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                customTile(Icons.business, 'Name', user.company!.name),
                customTile(Icons.campaign, 'Catch Phrase', user.company!.catchPhrase),
                customTile(Icons.work, 'BS', user.company!.bs),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget customTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
