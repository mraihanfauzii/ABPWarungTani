import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warungtani/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _nameErrorText = '';
  String _emailErrorText = '';
  String _passwordErrorText = '';
  String _confirmPasswordErrorText = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_confirmPasswordErrorText.isEmpty) {
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({'name': _nameController.text});

          // Navigasi ke halaman LoginPage setelah pendaftaran selesai
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
        } else {
          _showSnackBar('Registrasi gagal. Silahkan coba lagi!');
        }
      } catch (e) {
        print('Registrasi gagal: $e');
        _showSnackBar('Registrasi gagal. Silahkan coba lagi!');
      }
    }
  }

  void _validateName(String value) {
    setState(() {
      _nameErrorText = value.isNotEmpty ? '' : 'Nama lengkap tidak boleh kosong';
    });
  }

  void _validateEmail(String value) {
    setState(() {
      _emailErrorText = value.contains('@') ? '' : 'Format email tidak valid';
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _passwordErrorText = value.length >= 8 ? '' : 'Password setidaknya harus 8 karakter';
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordErrorText = 'Konfirmasi password tidak boleh kosong';
      } else if (value != _passwordController.text) {
        _confirmPasswordErrorText = 'Konfirmasi password tidak sesuai';
      } else {
        _confirmPasswordErrorText = '';
      }
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'images/Logo.png',
                    height: 250,
                    width: 250,
                  ),
                  TextFormField(
                    controller: _nameController,
                    onChanged: (value) => _validateName(value),
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      hintText: 'Masukkan nama lengkap',
                      errorText: _nameErrorText.isNotEmpty ? _nameErrorText : null,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  TextFormField(
                    controller: _emailController,
                    onChanged: (value) => _validateEmail(value),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Masukkan email',
                      errorText: _emailErrorText.isNotEmpty ? _emailErrorText : null,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  TextFormField(
                    controller: _passwordController,
                    onChanged: (value) => _validatePassword(value),
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Masukkan password',
                      errorText: _passwordErrorText.isNotEmpty ? _passwordErrorText : null,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: _togglePasswordVisibility,
                        child: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  TextFormField(
                    controller: _confirmPasswordController,
                    onChanged: (value) => _validateConfirmPassword(value),
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Masukkan konfirmasi password',
                      errorText: _confirmPasswordErrorText.isNotEmpty ? _confirmPasswordErrorText : null,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: _toggleConfirmPasswordVisibility,
                        child: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      primary: _confirmPasswordErrorText.isEmpty ? Colors.green : Colors.grey,
                      onPrimary: Colors.white,
                    ),
                    child: const Text('Daftar'),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah Pernah Buat Akun? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      GestureDetector(
                        child: const Text(
                          'Masuk',
                          style: TextStyle(color: Colors.green),
                        ),
                        onTap: () {
                          // Navigasi ke halaman login
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),

                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
