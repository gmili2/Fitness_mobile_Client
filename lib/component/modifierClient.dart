import 'dart:io';
import 'package:app_front/model/client.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModifierClientPage extends StatefulWidget {
  final Client client;

  ModifierClientPage({required this.client});

  @override
  _ModifierClientPageState createState() => _ModifierClientPageState();
}

class _ModifierClientPageState extends State<ModifierClientPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers pour les champs de saisie
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  File? _image;
  DateTime? _selectedRegistrationDate;
  DateTime? _expirationDate;

  @override
  void initState() {
    super.initState();
    // Pré-remplir les champs avec les données du client
    nameController.text = widget.client.first_name;
    lastnameController.text = widget.client.last_name ?? '';
    ageController.text = widget.client.age.toString();
    phoneNumberController.text = widget.client.phoneNumber ?? '';
    emailController.text = widget.client.email ?? '';
    _selectedRegistrationDate =
        DateTime.tryParse(widget.client.registrationDate);
    _expirationDate = DateTime.tryParse(widget.client.expirationDate);
  }

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

  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime?) onDateSelected) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      onDateSelected(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Client'),
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
                          ? Image.network(
                              widget.client.imageUrl,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
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
                      labelStyle: TextStyle(color: Colors.blue),
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
                      labelStyle: TextStyle(color: Colors.blue),
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
                      labelStyle: TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Age is required';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age <= 0) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  // Selection de la date d'inscription
                  GestureDetector(
                    onTap: () async {
                      _selectDate(context, _selectedRegistrationDate,
                          (selectedDate) {
                        setState(() {
                          _selectedRegistrationDate = selectedDate;
                        });
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedRegistrationDate != null
                                ? 'Registration Date: ${_selectedRegistrationDate!.toString().split(' ')[0]}'
                                : 'Select Registration Date',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Selection de la date d'expiration
                  GestureDetector(
                    onTap: () async {
                      _selectDate(context, _expirationDate, (selectedDate) {
                        setState(() {
                          _expirationDate = selectedDate;
                        });
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _expirationDate != null
                                ? 'Expiration Date: ${_expirationDate!.toString().split(' ')[0]}'
                                : 'Select Expiration Date',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Client updatedClient = Client(
                            first_name: nameController.text,
                            last_name: lastnameController.text,
                            age: int.parse(ageController.text),
                            phoneNumber: phoneNumberController.text,
                            email: emailController.text,
                            imageUrl: _image != null
                                ? _image!.path
                                : widget.client.imageUrl,
                            registrationDate: _selectedRegistrationDate
                                .toString()
                                .split(' ')[0],
                            expirationDate:
                                _expirationDate.toString().split(' ')[0],
                            user: widget.client.user);

                        Navigator.pop(context, updatedClient);
                      }
                    },
                    child: Text('Save'),
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
