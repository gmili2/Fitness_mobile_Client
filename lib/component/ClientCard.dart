import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_front/model/client.dart';

class ClientCard extends StatefulWidget {
  final Client client;
  final bool isExpired;
  final Duration timeRemaining;
  final Function() onTap;
  final Function() onDelete;

  const ClientCard({
    Key? key,
    required this.client,
    required this.isExpired,
    required this.timeRemaining,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  _ClientCardState createState() => _ClientCardState();
}

class _ClientCardState extends State<ClientCard> {
  late Duration _timeRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.timeRemaining;

    // Démarrer le chronomètre uniquement si le temps restant est positif
    if (!_timeRemaining.isNegative) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining = _timeRemaining - const Duration(seconds: 1);

        // Arrêter le timer si le temps est écoulé
        if (_timeRemaining.isNegative) {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Annuler le timer lorsque le widget est détruit
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return 'Expired';
    }
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '$days days, $hours hours, $minutes minutes, $seconds seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image en mode cover
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.network(
              widget.client.imageUrl,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isExpired
                    ? [
                        const Color.fromARGB(255, 206, 33, 33).withOpacity(0.8),
                        const Color.fromARGB(255, 181, 37, 26).withOpacity(0.5)
                      ]
                    : [
                        const Color.fromARGB(255, 73, 196, 137)
                            .withOpacity(0.7),
                        const Color.fromARGB(255, 62, 190, 66).withOpacity(0.4)
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Contenu principal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.client.first_name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'From: ${widget.client.registrationDate} to ${widget.client.expirationDate}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.white.withOpacity(0.9),
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Time remaining: ${_formatDuration(_timeRemaining)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: _timeRemaining.isNegative
                                  ? Colors.red[200]
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Icône "Éditer"
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: widget.onTap,
                ),
                // Icône "Supprimer"
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
