import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class TarjetaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pagar'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(),
            BlocBuilder<PagarBloc, PagarState>(
              buildWhen: (previous, current) => current.tarjetaActiva,
              builder: (_, state) {
                return Hero(
                  tag: state.tarjeta.cardNumber,
                  child: CreditCardWidget(
                      cardNumber: state.tarjeta.cardNumberHidden,
                      expiryDate: state.tarjeta.expiracyDate,
                      cardHolderName: state.tarjeta.cardHolderName,
                      cvvCode: state.tarjeta.cvv,
                      showBackView: false),
                );
              },
            ),
            Positioned(bottom: 0, child: TotalPayButton()),
          ],
        ));
  }
}
