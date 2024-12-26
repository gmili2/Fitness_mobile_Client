import 'package:app_front/component/ajouterClient.dart';
import 'package:app_front/component/modifierClient.dart';
import 'package:flutter/material.dart';
import 'package:app_front/model/client.dart';

class ClientDialog extends StatelessWidget {
  final Client? client;
  final bool isEdit;

  const ClientDialog({Key? key, this.client, this.isEdit = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? 'Update Client' : 'Add Client'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, color: Colors.red),
        ),
      ],
      content:
          isEdit ? ModifierClientPage(client: client!) : AjouterClientPage(),
    );
  }
}
