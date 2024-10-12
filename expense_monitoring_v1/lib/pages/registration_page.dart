import 'package:expense_monitoring_v1/api_service.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  ApiService apiService = ApiService();

  final _formKey = GlobalKey<FormState>();
  String userId = '';
  String userName = '';
  String userPassword = '';
  String userProduct = '';
  String userService = '';
  String userContact = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'User ID'),
                onSaved: (value) => userId = value!,
                validator: (value) => value!.isEmpty ? 'Please enter User ID' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onSaved: (value) => userName = value!,
                validator: (value) => value!.isEmpty ? 'Please enter Username' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => userPassword = value!,
                validator: (value) => value!.isEmpty ? 'Please enter Password' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Product'),
                onSaved: (value) => userProduct = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Service'),
                onSaved: (value) => userService = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact'),
                onSaved: (value) => userContact = value!,
                validator: (value) => value!.isEmpty ? 'Please enter Contact' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      // Call the registerUser method
                      Map<String, dynamic> response = await apiService.registerUser(
                        userId,
                        userName,
                        userPassword,
                        userProduct,
                        userService,
                        userContact,
                      );

                      // Handle response
                      if (response['success'] != null && response['success']) {
                        // Show a success message and navigate back
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration successful!')),
                        );
                        Navigator.pop(context); // Navigate back after registration
                      } else {
                        // Show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration failed: ${response['message']}')),
                        );
                      }
                    } catch (e) {
                      // Handle any errors
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
