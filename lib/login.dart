import 'package:flutter/material.dart';
import 'package:warungtani/home.dart';
import 'package:warungtani/register.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _emailErrorText = '';
  String _passwordErrorText = '';
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar("Email atau Password tidak boleh kosong!");
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Navigasi ke halaman Home setelah login berhasil
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false);
      } catch (e) {
        print('Login gagal: $e');
        _showSnackBar('Login gagal. Silahkan coba lagi !');
      }
    }
  }

  void _validateEmail(String value) {
    setState(() {
      _emailErrorText = value.contains('@') ? '' : 'Format email tidak valid';
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _passwordErrorText =
          value.length >= 8 ? '' : 'Password setidaknya harus 8 karakter';
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                    controller: _emailController,
                    onChanged: (value) => _validateEmail(value),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Masukkan email',
                      errorText:
                          _emailErrorText.isNotEmpty ? _emailErrorText : null,
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
                      errorText: _passwordErrorText.isNotEmpty
                          ? _passwordErrorText
                          : null,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: _togglePasswordVisibility,
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    child: const Text('Masuk'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Baru di Warung Tani? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      GestureDetector(
                        child: const Text(
                          'Daftar',
                          style: TextStyle(color: Colors.green),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
