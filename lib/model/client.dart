class Client {
  final String first_name;
  final String last_name; // Nouveau champ
  final int age; // Nouveau champ
  final String phoneNumber; // Nouveau champ
  final String email; // Nouveau champ
  final String imageUrl;
  final String registrationDate;
  final String expirationDate;
  final int user;
  int? id; // Champ id nullable (non requis)

  Client({
    required this.first_name,
    required this.last_name, // Ajouté
    required this.age, // Ajouté
    required this.phoneNumber, // Ajouté
    required this.email, // Ajouté
    required this.imageUrl,
    required this.registrationDate,
    required this.expirationDate,
    required this.user,
    this.id, // id nullable, non requis
  });

  // Setter pour `id`
  set setId(int? newId) {
    id = newId;
  }

  // Méthode pour créer une instance de Client à partir d'une carte JSON
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '', // Ajouté
      age: json['age'] ?? 0, // Ajouté
      phoneNumber: json['phone_number'] ?? '', // Ajouté
      email: json['email'] ?? '', // Ajouté
      imageUrl: json['image_path'] ?? '',
      registrationDate: json['registration_date'] ?? '',
      expirationDate: json['expiration_date'] ?? '',
      user: json['user_id'] ?? 0, // Ajouté une valeur par défaut (0)
      id: json['id'], // id nullable, ne pose pas de problème si absent
    );
  }

  // Méthode pour convertir un Client en format JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // N'ajouter id que s'il n'est pas nul
      'first_name': first_name,
      'last_name': last_name,
      'age': age
          .toString(), // Assurez-vous que l'âge est sous forme de chaîne si nécessaire
      'phone_number': phoneNumber,
      'email': email,
      'image_path': imageUrl,
      'registration_date': registrationDate,
      'expiration_date': expirationDate,
      'user_id': user,
    };
  }

  @override
  String toString() {
    return 'Client(id: $id, name: $first_name, lastname: $last_name, age: $age, phoneNumber: $phoneNumber, email: $email, imageUrl: $imageUrl, registrationDate: $registrationDate)';
  }
}
