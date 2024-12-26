import 'package:flutter/material.dart';
import 'package:app_front/controller/client_controller.dart';
import 'package:app_front/model/client.dart';
import 'package:app_front/component/ClientDialog.dart';
import 'package:app_front/component/LoadingIndicator.dart';
import 'package:app_front/component/TopSearchBar.dart';
import 'package:app_front/component/ClientCard.dart';

final ClientController controller = ClientController();

class ClientsContent extends StatefulWidget {
  const ClientsContent();

  @override
  _ClientsContentState createState() => _ClientsContentState();
}

class _ClientsContentState extends State<ClientsContent> {
  List<Client> clients = [];
  List<Client> filteredClients = [];
  bool _isLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAllClients();
  }

  Future<void> _fetchAllClients() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fetchedClients = await controller.getAllClients();
      setState(() {
        clients = fetchedClients;
        filteredClients = fetchedClients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des clients'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  void filterClients(String query) {
    setState(() {
      filteredClients = clients
          .where((client) =>
              client.first_name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  bool isClientExpired(Client client) {
    DateTime expirationDate = DateTime.parse(client.expirationDate);
    DateTime now = DateTime.now();
    return expirationDate.isBefore(now);
  }

  Duration _calculateTimeRemaining(Client client) {
    DateTime expirationDate = DateTime.parse(client.expirationDate);
    DateTime now = DateTime.now();
    return expirationDate.difference(now);
  }

  Future<void> _showClientDialog(Client? client, {bool isEdit = false}) async {
    setState(() {
      _isLoading = true;
    });

    Client? updatedClient = await showDialog<Client>(
      context: context,
      builder: (BuildContext context) {
        return ClientDialog(client: client, isEdit: isEdit);
      },
    );

    if (updatedClient != null) {
      try {
        if (isEdit) {
          updatedClient.setId = client?.id;
          await controller.updateClient(updatedClient);
        } else {
          await controller.addClient(updatedClient);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Client mis à jour' : 'Client ajouté'),
            backgroundColor: Colors.green[400],
          ),
        );
        _fetchAllClients();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _deleteClient(Client client) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await controller.deleteClient(client);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Client supprimé'),
          backgroundColor: Colors.green[400],
        ),
      );
      _fetchAllClients();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red[400],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showDeleteConfirmationDialog(Client client) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181828),
        title: const Text(
          'Supprimer ce client ?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer ce client ?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteClient(client);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E), // Fond sombre
      body: _isLoading
          ? LoadingIndicator()
          : Column(
              children: [
                TopSearchBar(
                  controller: searchController,
                  onChanged: filterClients,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredClients.length,
                    itemBuilder: (context, index) {
                      Client client = filteredClients[index];
                      bool isExpired = isClientExpired(client);
                      Duration timeRemaining = _calculateTimeRemaining(client);

                      return ClientCard(
                        client: client,
                        isExpired: isExpired,
                        timeRemaining: timeRemaining,
                        onTap: () {
                          _showClientDialog(client, isEdit: true);
                        },
                        onDelete: () {
                          _showDeleteConfirmationDialog(client);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showClientDialog(null, isEdit: false);
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
