import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stripe_app/models/payment_intent_response.dart';
import 'package:stripe_app/models/stripe_custom_response.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  static final StripeService _instancia = new StripeService.internal();

  factory StripeService() {
    return _instancia;
  }

  StripeService.internal();

  String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static String _secretKey =
      'sk_test_51IqOMRDAUOMROdAo47fPlpVdn21BeVhwrrWirXoPoZK6hnZYcF3FcJQdVj6DYALi7EdaAYEscBUohEmmBPXwf93S000rzEMzCx';
  String _apiKey =
      'pk_test_51IqOMRDAUOMROdAogHgBXT6o30y1TuxF3WCXrnljd0Izj9vFb1SZEBlknLEeSUvOjXODO72ToMWQka9xB8QPMY3H00yXTG0lnf';
  final headerOptions = new Options(
      contentType: Headers.formUrlEncodedContentType,
      headers: {'Authorization': 'Bearer ${StripeService._secretKey}'});
  void init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: this._apiKey,
        androidPayMode: 'test',
        merchantId: 'test'));
  }

  Future<StripeCustomResponse> pagarConTarjetaExistente({
    @required String amount,
    @required String currency,
    @required CreditCard card,
  }) async {
    try {
      final paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));

      final resp = await this._realizarPago(
          amount: amount, currency: currency, paymentMethod: paymentMethod);
      return resp;
    } catch (e) {
      return StripeCustomResponse(ok: false, msj: e.toString());
    }
  }

  Future<StripeCustomResponse> pagarConNuevaTarjeta({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());

      final resp = await this._realizarPago(
          amount: amount, currency: currency, paymentMethod: paymentMethod);
      return resp;
    } catch (e) {
      return StripeCustomResponse(ok: false, msj: e.toString());
    }
  }

  Future<StripeCustomResponse> pagarApplePayAndGooglePay({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final newAmount = double.parse(amount) / 100;
      final token = await StripePayment.paymentRequestWithNativePay(
          androidPayOptions: AndroidPayPaymentRequest(
              totalPrice: amount, currencyCode: currency),
          applePayOptions: ApplePayPaymentOptions(
              countryCode: 'US',
              currencyCode: currency,
              items: [
                ApplePayItem(label: 'Producto 1', amount: '$newAmount')
              ]));

      final paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: CreditCard(token: token.tokenId)));

      final resp = await this._realizarPago(
          amount: amount, currency: currency, paymentMethod: paymentMethod);
      StripePayment.completeNativePayRequest();
      return resp;
    } catch (e) {
      print(e.toString());
      return StripeCustomResponse(ok: false, msj: e.toString());
    }
  }

  Future<PaymentIntentResponse> _crearPaymentIntent({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final dio = new Dio();
      final data = {
        'currency': currency,
        'amount': amount,
        'payment_method_types[]': 'card'
      };
      final resp =
          await dio.post(_paymentApiUrl, data: data, options: headerOptions);
      return PaymentIntentResponse.fromJson(resp.data);
    } catch (e) {
      return PaymentIntentResponse(status: '400');
    }
  }

  Future<StripeCustomResponse> _realizarPago(
      {@required String amount,
      @required String currency,
      @required PaymentMethod paymentMethod}) async {
    try {
      //Crear intener
      final respuesta =
          await this._crearPaymentIntent(amount: amount, currency: currency);

      final paymentResult = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: respuesta.clientSecret,
              paymentMethodId: paymentMethod.id));

      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(
          ok: true,
        );
      } else {
        return StripeCustomResponse(
            ok: false, msj: 'Fallo ${respuesta.status} ');
      }
    } catch (e) {
      print(e.toString());
      return StripeCustomResponse(ok: false, msj: e.toString());
    }
  }
}
