import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warungtani/login.dart';
import 'package:warungtani/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan indikator loading jika masih dalam proses inisialisasi Firebase
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Tampilkan pesan error jika terjadi kesalahan dalam inisialisasi Firebase
          return Text('Error: ${snapshot.error}');
        } else {
          // Pemeriksaan status login dan menentukan halaman yang akan ditampilkan
          return MaterialApp(
            title: 'WarungTani',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => FutureBuilder<bool>(
                future: checkUserLoggedIn(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Tampilkan indikator loading jika masih dalam proses pengecekan
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.data == true) {
                      // Pengguna sudah login, tampilkan halaman home
                      return MainScreen();
                    } else {
                      // Pengguna belum login, tampilkan halaman login
                      return LoginPage();
                    }
                  }
                },
              ),
              '/home': (context) => MainScreen(),
              '/login': (context) => LoginPage(),
            },
          );
        }
      },
    );
  }

  Future<bool> checkUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
