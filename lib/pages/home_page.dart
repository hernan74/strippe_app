import 'package:flutter/material.dart';

import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/data/tarjetas.dart';

import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/tarjeta_page.dart';
import 'package:stripe_app/services/stripe_service.dart';

import 'package:stripe_app/widgets/total_pay_button.dart';

class HomePage extends StatelessWidget {
  final stripeService = new StripeService();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pagarState = context.read<PagarBloc>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              mostrarLoading(context);
              final res = await this.stripeService.pagarConNuevaTarjeta(
                  amount: pagarState.montoPagarString,
                  currency: pagarState.moneda);
              Navigator.pop(context);
              if (res.ok) {
                mostrarAlerta(context, 'Tarjeta OK', 'Todo correcto');
              } else {
                mostrarAlerta(context, 'Algo salio mal', res.msj);
              }
              // mostrarAlerta(context, 'titulo', 'mundo');
              // await Future.delayed(Duration(seconds: 1));
              // Navigator.pop(context);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            width: size.width,
            height: size.height,
            top: 200,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              physics: BouncingScrollPhysics(),
              itemCount: tarjetas.length,
              itemBuilder: (_, i) {
                final tarjeta = tarjetas[i];
                return GestureDetector(
                  onTap: () async {
                    context
                        .read<PagarBloc>()
                        .add(OnSeleccionarTarjetaEvent(tarjeta));
                    await Navigator.push(
                        context, navegarFadeIn(context, TarjetaPage()));
                    context.read<PagarBloc>().add(OnDesactivarTarjeta());
                  },
                  child: Hero(
                    tag: tarjeta.cardNumber,
                    child: CreditCardWidget(
                        cardNumber: tarjeta.cardNumberHidden,
                        expiryDate: tarjeta.expiracyDate,
                        cardHolderName: tarjeta.cardHolderName,
                        cvvCode: tarjeta.cvv,
                        showBackView: false),
                  ),
                );
              },
            ),
          ),
          Positioned(bottom: 0, child: TotalPayButton()),
        ],
      ),
    );
  }
}
