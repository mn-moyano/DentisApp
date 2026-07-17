class Pago {
  final int? idPago;
  final DateTime fechaPago;
  final double monto;
  final String metodoPago;
  final int idCita;

  Pago({
    this.idPago,
    required this.fechaPago,
    required this.monto,
    required this.metodoPago,
    required this.idCita,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_pago': idPago,
      'fecha_pago': fechaPago.toIso8601String(),
      'monto': monto,
      'metodo_pago': metodoPago,
      'id_cita': idCita,
    };
  }

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