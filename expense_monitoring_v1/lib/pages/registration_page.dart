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
  String userPasswd = '';
  String phoneNumber = '';

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
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => userPasswd = value!,
                validator: (value) => value!.isEmpty ? 'Please enter Password' : null,
              ),
              
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                onSaved: (value) => phoneNumber = value!,
                validator: (value) => value!.isEmpty ? 'Please enter Phone Number' : null,
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    
                    try {
                      Map<String, dynamic> response = await apiService.registerUser(
                        userId,
                        userPasswd,
                        phoneNumber
                      );

                      // Handle response
                      if (response['success'] != null && response['success']) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration successful!')),
                        );
                        Navigator.pop(context); // Navigate back after registration
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration failed: ${response['message']}')),
                        );
                      }
                    } catch (e) {
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
