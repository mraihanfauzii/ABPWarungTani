import 'package:flutter/material.dart';
import 'package:warungtani/home.dart';

class PaymentSuccessPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Pembayaran Berhasil',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 24.0, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),

              const SizedBox(height: 32),

              Image.asset(
                'images/donepayment.png',
                height: 150,
                width: 150,),

              const SizedBox(height: 32),

              const Text(
                  'Terimakasih Atas Pesanannya',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),

              const Text(
                  'Pesanan anda akan kami proses secepatnya',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14.0, fontFamily: 'Montserrat')),

              const SizedBox(height: 16),

              ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (context) => MainScreen()),
                            (route) => false);
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                  ),
                  child: const Text("Kembali ke Home")),
            ],
          ),
        ),
      );
  }
}