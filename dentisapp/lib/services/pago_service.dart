import '../models/pago.dart';

class PagoService {
  final List<Pago> _pagos = [
    Pago(
      idPago: 1,
      fechaPago: DateTime(2026, 7, 20),
      monto: 35.00,
      metodoPago: 'Efectivo',
      idCita: 1,
    ),
    Pago(
      idPago: 2,
      fechaPago: DateTime(2026, 7, 21),
      monto: 60.00,
      metodoPago: 'Tarjeta',
      idCita: 2,
    ),
    Pago(
      idPago: 3,
      fechaPago: DateTime(2026, 7, 22),
      monto: 80.00,
      metodoPago: 'Transferencia',
      idCita: 3,
    ),
  ];

  /// Obtener todos los pagos
  List<Pago> obtenerPagos() {
    return _pagos;
  }

  /// Obtener pago por ID
  Pago? obtenerPagoPorId(int id) {
    try {
      return _pagos.firstWhere(
        (pago) => pago.idPago == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Agregar pago
  void agregarPago(Pago pago) {
    _pagos.add(pago);
  }

  /// Actualizar pago
  void actualizarPago(Pago pagoActualizado) {
    final index = _pagos.indexWhere(
      (p) => p.idPago == pagoActualizado.idPago,
    );

    if (index != -1) {
      _pagos[index] = pagoActualizado;
    }
  }

  /// Eliminar pago
  void eliminarPago(int id) {
    _pagos.removeWhere(
      (pago) => pago.idPago == id,
    );
  }
}