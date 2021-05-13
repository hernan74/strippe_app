import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

class TotalPayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final pagarBloc = context.read<PagarBloc>();
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
              Text('${pagarBloc.state.montoPagar} ${pagarBloc.state.moneda} ',
                  style: TextStyle(fontSize: 20)),
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
      onPressed: () async {
        mostrarLoading(context);
        final pagarBloc = context.read<PagarBloc>().state;
        final stripeService = new StripeService();
        final creditCard = new CreditCard(
            number: pagarBloc.tarjeta.cardNumber,
            expMonth: int.parse(pagarBloc.tarjeta.expiracyDate.split('/')[0]),
            expYear: int.parse(pagarBloc.tarjeta.expiracyDate.split('/')[1]));
        final resp = await stripeService.pagarConTarjetaExistente(
            amount: pagarBloc.montoPagarString,
            currency: pagarBloc.moneda,
            card: creditCard);
        Navigator.pop(context);
        if (resp.ok) {
          mostrarAlerta(context, 'Tarjeta OK', 'Todo correcto');
        } else {
          mostrarAlerta(context, 'Algo salio mal', resp.msj);
        }
      },
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
      onPressed: () async {
        final stripeService = new StripeService();
        final pagarBloc = context.read<PagarBloc>().state;
        final resp = stripeService.pagarApplePayAndGooglePay(
            amount: pagarBloc.montoPagarString, currency: pagarBloc.moneda);
            
      },
    );
  }
}
