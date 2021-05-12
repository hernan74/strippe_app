import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PagoCompletoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pago realizado'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.star,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(
              height: 20,
            ),
            Text('Pago realizado',
                style: TextStyle(fontSize: 22, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
