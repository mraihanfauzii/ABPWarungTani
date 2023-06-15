import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warungtani/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warung Tani',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String password = '';
  String profilePicture = '';

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            name = snapshot.data()!['name'];
            email = user.email ?? '';
          });
        }
      });
    }
  }

  void updateProfile(String newName, String newEmail, String newProfilePicture) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateEmail(newEmail);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': newName,
        'email': newEmail,
      });
      setState(() {
        name = newName;
        email = newEmail;
        profilePicture = newProfilePicture;
      });
    }
  }

  void updatePassword(String newPassword) {
    // Implement password update logic here
  }

  void deleteAccount() async {
    // Implement delete account logic here
    await FirebaseAuth.instance.currentUser?.delete();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Action when settings button is pressed
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Action when Edit Profile button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        name: name,
                        email: email,
                        password: password,
                        profilePicture: profilePicture,
                        onUpdateProfile: updateProfile,
                        onUpdatePassword: updatePassword,
                        onDeleteAccount: deleteAccount,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Informasi Akun'),
            onTap: () {
              // Action when Account Information option is pressed
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Alamat Pengiriman'),
            onTap: () {
              // Action when Shipping Address option is pressed
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Metode Pembayaran'),
            onTap: () {
              // Action when Payment Methods option is pressed
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Produk Favorit'),
            onTap: () {
              // Action when Favorite Products option is pressed
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('Daftar Transaksi'),
            onTap: () {
              // Action when Transaction History option is pressed
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Ulasan'),
            onTap: () {
              // Action when Reviews option is pressed
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Gudang'),
            onTap: () {
              // Action when Store option is pressed
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('Logout'),
                        onPressed: () async {
                          // Perform logout action here
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                                (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String profilePicture;
  final Function(String, String, String) onUpdateProfile;
  final Function(String) onUpdatePassword;
  final VoidCallback onDeleteAccount;

  const EditProfilePage({super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.profilePicture,
    required this.onUpdateProfile,
    required this.onUpdatePassword,
    required this.onDeleteAccount,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late String name;
  late String email;
  late String password;
  late String profilePicture;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool showPassword = false;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController(text: widget.password);
    name = widget.name;
    email = widget.email;
    password = widget.password;
    email = widget.email;
    password = '';
    profilePicture = widget.profilePicture;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submitProfile() {
    String newName = nameController.text;
    String newEmail = emailController.text;
    String password = passwordController.text;
    String newProfilePicture = profilePicture;

    // Verifikasi password dengan akun Firebase
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password
      );

      user.reauthenticateWithCredential(credential).then((authResult) {
        // Password valid, update profil
        widget.onUpdateProfile(newName, newEmail, newProfilePicture);
        Navigator.pop(context);
      }).catchError((error) {
        // Password tidak valid, tampilkan pesan error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Password tidak valid.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  void submitPassword() {
    String password = passwordController.text;

    if (password.isNotEmpty) {
      // Verifikasi password dengan akun Firebase
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        user.reauthenticateWithCredential(credential).then((authResult) {
          // Password valid, update password
          widget.onUpdatePassword(password);
          Navigator.pop(context);
        }).catchError((error) {
          // Password tidak valid, tampilkan pesan error
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Password tidak valid.'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Password dan Konfirmasi Password tidak sesuai.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> checkRecentLogin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      DateTime? lastSignInTime = user.metadata.lastSignInTime;
      if (lastSignInTime != null) {
        DateTime currentTime = DateTime.now();
        Duration difference = currentTime.difference(lastSignInTime);
        if (difference.inMinutes <= 5) {
          return true;
        }
      }
    }
    return false;
  }

  void deleteAccount() async {
    bool isRecentLogin = await checkRecentLogin();
    if (isRecentLogin) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hapus Akun'),
            content: Text('Apakah Anda yakin ingin menghapus akun?'),
            actions: [
              TextButton(
                child: Text('Batal'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Hapus'),
                onPressed: () async {
                  // Perform delete account action here
                  // You can use the FirebaseAuth instance to delete the current user's account
                  // After the account is deleted, navigate the user back to the login page
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await user.delete();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Mohon Login Ulang Sebelum Menghapus Akun'),
            content: const Text('Operasi ini memerlukan otentikasi baru. Silakan login kembali dan lakukan ulang tahap sebelumnya agar anda dapat menghapus akun anda.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate user back to login page
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(profilePicture),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Nama',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: nameController,
                onChanged: (value) {
                  // Tidak perlu mengubah state secara langsung karena sudah menggunakan TextEditingController
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: emailController,
                onChanged: (value) {
                  // Tidak perlu mengubah state secara langsung karena sudah menggunakan TextEditingController
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: passwordController,
                obscureText: !showPassword,
                onChanged: (value) {
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: submitProfile,
                    child: Text('Simpan Perubahan'),
                  ),
                  ElevatedButton(
                    onPressed: deleteAccount,
                    child: Text('Hapus Akun'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
