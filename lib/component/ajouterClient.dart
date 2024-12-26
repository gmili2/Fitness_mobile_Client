import 'dart:io';
import 'package:app_front/model/client.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AjouterClientPage extends StatefulWidget {
  @override
  _AjouterClientPageState createState() => _AjouterClientPageState();
}

class _AjouterClientPageState extends State<AjouterClientPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers pour les champs de saisie
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController registrationDateController =
      TextEditingController();
  final TextEditingController expirationDateController =
      TextEditingController();

  File? _image;

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text =
            pickedDate.toIso8601String().split('T')[0]; // Format: yyyy-MM-dd
      });
    }
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null || age <= 0) {
      return 'Please enter a valid age greater than 0';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\d{10}$'); // Exemple : 10 chiffres
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number (10 digits)';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'); // Validation basique pour un email
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Client'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: getImage,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _image == null
                          ? Icon(Icons.person, size: 80, color: Colors.grey)
                          : ClipOval(
                              child: Image.file(_image!, fit: BoxFit.cover),
                            ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: lastnameController,
                    decoration: InputDecoration(
                      labelText: 'Lastname',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lastname is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    validator: validateAge,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: validatePhoneNumber,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: validateEmail,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: registrationDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Registration Date',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () =>
                            _selectDate(context, registrationDateController),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a registration date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: expirationDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Expiration Date',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () =>
                            _selectDate(context, expirationDateController),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an expiration date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      print(
                          "registrationDateController ${registrationDateController.text}");
                      if (_formKey.currentState!.validate()) {
                        // Collect data and navigate back
                        print('All fields validated');
                        String registrationDateString =
                            registrationDateController.text;
                        DateTime registrationDate =
                            DateTime.parse(registrationDateString);
                        Client newClient = Client(
                            first_name: nameController.text,
                            last_name: lastnameController.text,
                            age: int.parse(ageController.text),
                            phoneNumber: phoneNumberController.text,
                            email: emailController.text,
                            imageUrl: _image != null ? _image!.path : '',
                            registrationDate: registrationDateController.text,
                            expirationDate: expirationDateController.text,
                            user: 1);

                        Navigator.pop(context, newClient);
                      }
                    },
                    child: Text('Add Client'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
