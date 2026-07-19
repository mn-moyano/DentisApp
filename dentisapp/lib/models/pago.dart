/// Modelo que representa un pago registrado en el sistema.
class Pago {
  /// Identificador único del pago.
  final int? idPago;

  /// Fecha en la que se realizó el pago.
  final DateTime fechaPago;

  /// Monto pagado.
  final double monto;

  /// Método de pago utilizado.
  final String metodoPago;

  /// Identificador de la cita asociada al pago.
  final int idCita;

  Pago({
    this.idPago,
    required this.fechaPago,
    required this.monto,
    required this.metodoPago,
    required this.idCita,
  });

  /// Convierte el pago a un mapa de datos.
  Map<String, dynamic> toMap() {
    return {
      'id_pago': idPago,
      'fecha_pago': fechaPago.toIso8601String(),
      'monto': monto,
      'metodo_pago': metodoPago,
      'id_cita': idCita,
    };
  }

  /// Crea un pago a partir de un mapa recibido.
  factory Pago.fromMap(Map<String, dynamic> map) {
    return Pago(
      idPago: map['id_pago'],
      fechaPago: DateTime.parse(map['fecha_pago']),
      monto: (map['monto'] as num).toDouble(),
      metodoPago: map['metodo_pago'],
      idCita: map['id_cita'],
    );
  }
}