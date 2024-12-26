import 'package:flutter/material.dart';
import 'package:app_front/model/client.dart';
class ClientDetailPage extends StatelessWidget {
  final Client client;

  ClientDetailPage({required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(client.imageUrl),
              radius: 50,
            ),
            SizedBox(height: 20),
            Text('Name: ${client.first_name}'),
            SizedBox(height: 10),
            Text('Registration Date: ${client.registrationDate}'),
          ],
        ),
      ),
    );
  }
}
