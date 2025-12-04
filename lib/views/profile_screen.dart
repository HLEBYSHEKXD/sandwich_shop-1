import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile / Sign-In', style: heading1),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _submitted
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Details', style: heading2),
                  const SizedBox(height: 20),
                  Text('Name: ${_name ?? ''}', style: normalText),
                  const SizedBox(height: 10),
                  Text('Email: ${_email ?? ''}', style: normalText),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Order'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter your details', style: heading2),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter your name' : null,
                      onSaved: (value) => _name = value,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter your email' : null,
                      onSaved: (value) => _email = value,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Submit'),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          setState(() {
                            _submitted = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
