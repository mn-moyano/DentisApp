import '../models/pago.dart';

/// Servicio local para manejar los pagos del sistema.
class PagoService {
  /// Lista en memoria con pagos de ejemplo.
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

  /// Devuelve todos los pagos registrados localmente.
  List<Pago> obtenerPagos() {
    return _pagos;
  }

  /// Busca un pago por su identificador.
  Pago? obtenerPagoPorId(int id) {
    try {
      return _pagos.firstWhere(
        (pago) => pago.idPago == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Agrega un nuevo pago a la lista local.
  void agregarPago(Pago pago) {
    _pagos.add(pago);
  }

  /// Actualiza un pago existente.
  void actualizarPago(Pago pagoActualizado) {
    final index = _pagos.indexWhere(
      (p) => p.idPago == pagoActualizado.idPago,
    );

    if (index != -1) {
      _pagos[index] = pagoActualizado;
    }
  }

  /// Elimina un pago por su identificador.
  void eliminarPago(int id) {
    _pagos.removeWhere(
      (pago) => pago.idPago == id,
    );
  }
}