import 'package:flutter/material.dart';
import 'package:warungtani/keranjang.dart';
import 'package:warungtani/repository/cart_repository.dart';
import 'models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailScreen extends StatelessWidget {
  final Product item;

  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
          return DetailMobilePage(item: item);
      },
    );
  }
}

class DetailMobilePage extends StatelessWidget {
  final Product item;

  const DetailMobilePage({Key? key, required this.item}) : super(key: key);

  Future<String> getUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user!.uid;
  }

  //function to convert firebase string uid to integer by getting only the integers
  Future<int> getUid() async {
    String uid = await getUserId();
    String newUid = uid.replaceAll(RegExp(r'[^0-9]'), '');
    int intUid = int.parse(newUid);
    return intUid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.network(item.imageLink,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    fit: BoxFit.cover),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const FavoriteButton()
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'Montserrat',
                  ),
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Icon(Icons.monetization_on),
                      const SizedBox(height: 8.0),
                      Text((item.price).toString()),
                    ],
                  ),
                  Column(
                    children: const <Widget>[
                      Icon(Icons.access_time),
                      SizedBox(height: 8.0),
                      Text("Pengiriman Cepat"),
                    ],
                  ),
                  Column(
                    children: const <Widget>[
                      Icon(Icons.local_shipping),
                      SizedBox(height: 8.0),
                      Text("Gratis Ongkir"),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    'images/Gudang.png',
                    width: 40,
                    height: 40,
                  ),
                  Column(
                    children: const <Widget>[
                      Text("Gudang Buahbatu",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          )),
                      SizedBox(height: 4.0),
                      Text("JURAGAN PASAR",
                          style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Montserrat',
                          )),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print('Tombol ditekan!');
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightGreen),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
                      child: const Text("Detail Gudang")),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 16.0),
                child: const Text('Deskripsi Produk',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold))),
            Container(
              margin: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Text(
                item.description,
                textAlign: TextAlign.justify,
                style:
                    const TextStyle(fontSize: 16.0, fontFamily: 'Montserrat'),
              ),
            ),
            Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () {
                    getUid().then(
                        (value) => CartRepository.addToCart(value, item.id, 1));
                    print('Tombol Keranjang ditekan!');
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightGreen),
                  ),
                  child: const Text("Keranjang")),
              const SizedBox(width: 15),
              ElevatedButton(
                  onPressed: () {
                    print('Tombol Order ditekan!');
                    getUid().then(
                        (value) => CartRepository.addToCart(value, item.id, 1));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightGreen),
                  ),
                  child: const Text("Order")),
              const SizedBox(height: 15)
            ]))
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
