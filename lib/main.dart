import 'package:flutter/material.dart';
import 'package:stripe_app/pages/home_page.dart';
import 'package:stripe_app/pages/pago_completo_page.dart';
import 'package:stripe_app/pages/tarjeta_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stripe App',
      initialRoute: '/',
      routes: {
        '/'      : (_) => HomePage(),
        'pago'   : (_) => PagoCompletoPage(),
        'tarjeta': (_) => TarjetaPage(),
      },
      theme: ThemeData.light().copyWith(
          primaryColor: Color(0xff184879),
          scaffoldBackgroundColor: Color(0xff21232A)),
    );
  }
}
