import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';

class TotalPayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Total',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('255.55 USD', style: TextStyle(fontSize: 20)),
            ],
          ),
          BlocBuilder<PagarBloc, PagarState>(
            builder: (context, state) {
              return _BtnPay(
                tarjetaActiva: state.tarjetaActiva,
              );
            },
          )
        ],
      ),
    );
  }
}

class _BtnPay extends StatelessWidget {
  final bool tarjetaActiva;

  const _BtnPay({this.tarjetaActiva});
  @override
  Widget build(BuildContext context) {
    return tarjetaActiva
        ? buildBotonTarjeta(context)
        : buildAppleAndGooglePay(context);
  }

  Widget buildBotonTarjeta(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: StadiumBorder(),
      color: Colors.black,
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.solidCreditCard,
            color: Colors.white,
            size: 22,
          ),
          Text(
            '  Pagar',
            style: TextStyle(color: Colors.white, fontSize: 22),
          )
        ],
      ),
      onPressed: () {},
    );
  }

  Widget buildAppleAndGooglePay(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: StadiumBorder(),
      color: Colors.black,
      child: Row(
        children: <Widget>[
          Icon(
            Platform.isAndroid
                ? FontAwesomeIcons.google
                : FontAwesomeIcons.apple,
            color: Colors.white,
            size: 22,
          ),
          Text(
            '  Pagar',
            style: TextStyle(color: Colors.white, fontSize: 22),
          )
        ],
      ),
      onPressed: () {},
    );
  }
}
