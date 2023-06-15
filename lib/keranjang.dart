import 'package:flutter/material.dart';
import 'package:warungtani/pembayaran_sukses.dart';
import 'models/cart_detail.dart';
import 'models/product.dart';
import 'repository/cart_repository.dart';
import 'repository/product_repository.dart';
import 'repository/order_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartRepository _cartRepository = CartRepository();
  List<Product> products = [];
  List<CartDetail> cartDetailsForUser = [];
  List<Product> cartProducts = [];

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
  void initState() {
    super.initState();
    getUid().then((value) {
      _cartRepository.getCartDetailsForUser(value).then((value) {
        setState(() {
          cartDetailsForUser = value;
          updateCartProducts();
        });
      }).catchError((error) {
        print('error getting cart: $error');
      });
      ProductRepository.getProducts().then((value) {
        setState(() {
          products = value;
          updateCartProducts();
        });
      }).catchError((error) {
        print('error getting products: $error');
      });
    });
  }

  void updateCartProducts() {
    if (cartDetailsForUser.isNotEmpty && products.isNotEmpty) {
      cartProducts.clear();
      for (Product product in products) {
        for (CartDetail cartDetail in cartDetailsForUser) {
          if (product.id == cartDetail.productId) {
            cartProducts.add(product);
            break;
          }
        }
      }
    }
  }

  void removeItem(int index) async {
    await _cartRepository.updateCartDetail(
      cartDetailsForUser[index].id,
      0,
    );
    setState(() {
      cartDetailsForUser.removeAt(index);
      cartProducts.removeAt(index);
    });
  }

  void incrementQuantity(int index) async {
    await _cartRepository.updateCartDetail(
      cartDetailsForUser[index].id,
      cartDetailsForUser[index].quantity + 1,
    );
    setState(() {
      cartDetailsForUser[index].quantity += 1;
    });
  }

  void decrementQuantity(int index) async {
    await _cartRepository.updateCartDetail(
      cartDetailsForUser[index].id,
      cartDetailsForUser[index].quantity - 1,
    );
    setState(() {
      cartDetailsForUser[index].quantity -= 1;
      if (cartDetailsForUser[index].quantity == 0) {
        cartDetailsForUser.removeAt(index);
        cartProducts.removeAt(index);
      }
    });
  }

  int calculateTotalPrice() {
    int total = 0;
    for (int i = 0; i < cartProducts.length; i++) {
      total += cartProducts[i].price * cartDetailsForUser[i].quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: cartProducts.length,
        itemBuilder: (context, index) {
          return CartItemWidget(
            quantity: cartDetailsForUser[index].quantity,
            cartItem: cartProducts[index],
            onRemove: () {
              removeItem(index);
            },
            onIncrement: () {
              incrementQuantity(index);
            },
            onDecrement: () {
              decrementQuantity(index);
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Harga: Rp ${calculateTotalPrice()}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action when Checkout button is pressed
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Checkout'),
                          content: Text('Total: Rp ${calculateTotalPrice()}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                getUid().then((value) =>
                                    OrderRepository.checkoutOrder(value));
                                setState(() {
                                  cartDetailsForUser.clear();
                                  cartProducts.clear();
                                });
                                // Action when Confirm button is pressed
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Checkout Successful'),
                                  ),
                                );
                                Navigator.pushAndRemoveUntil(
                                    context, MaterialPageRoute(builder: (context) => PaymentSuccessPage()),
                                        (route) => false);
                              },
                              child: Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Checkout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final int quantity;
  final Product cartItem;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemWidget({
    required this.quantity,
    required this.cartItem,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              cartItem.imageLink,
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text('Price: Rp ${cartItem.price}'),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: onDecrement,
                      ),
                      Text('${quantity}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: onIncrement,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: onRemove,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
