part of 'pagar_bloc.dart';

@immutable
abstract class PagarEvent {}

class OnSeleccionarTarjetaEvent extends PagarEvent {
  final TarjetaCredito tarjeta;

  OnSeleccionarTarjetaEvent(this.tarjeta);
}

class OnDesactivarTarjeta extends PagarEvent {}
