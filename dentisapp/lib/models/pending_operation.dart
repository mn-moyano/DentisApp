import 'dart:convert';

/// Representa una operación pendiente de sincronización.
///
/// Se utiliza cuando el usuario realiza una acción sin conexión,
/// por ejemplo:
///
/// - Crear un paciente.
/// - Actualizar un paciente.
/// - Eliminar un paciente.
///
/// La operación permanece almacenada en SQLite hasta que pueda
/// enviarse correctamente al servidor.
class PendingOperation {
  /// Identificador interno de SQLite.
  final int? id;

  /// Identificador único de la operación.
  ///
  /// Se genera mediante UUID para evitar duplicados durante
  /// los reintentos de sincronización.
  final String operationId;

  /// Tipo de entidad relacionada con la operación.
  ///
  /// Ejemplo:
  /// paciente
  final String entityType;

  /// Tipo de operación.
  ///
  /// Ejemplos:
  /// create
  /// update
  /// delete
  final String operationType;

  /// Identificador único generado por el cliente.
  ///
  /// Permite identificar registros creados sin conexión,
  /// incluso antes de recibir un ID del servidor.
  final String clientId;

  /// Datos necesarios para ejecutar la operación.
  ///
  /// Se almacena como Map en la aplicación y como JSON
  /// dentro de SQLite.
  final Map<String, dynamic> payload;

  /// Número de intentos de sincronización realizados.
  final int attempts;

  /// Fecha en la que se creó la operación.
  final DateTime createdAt;

  /// Fecha programada para el siguiente intento.
  ///
  /// Se utiliza para implementar la espera creciente
  /// entre reintentos.
  final DateTime? nextRetryAt;

  /// Último error ocurrido durante la sincronización.
  final String? lastError;

  const PendingOperation({
    this.id,
    required this.operationId,
    required this.entityType,
    required this.operationType,
    required this.clientId,
    required this.payload,
    this.attempts = 0,
    required this.createdAt,
    this.nextRetryAt,
    this.lastError,
  });

  /// Convierte la operación a un Map compatible con SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'operation_id': operationId,
      'entity_type': entityType,
      'operation_type': operationType,
      'client_id': clientId,
      'payload': jsonEncode(payload),
      'attempts': attempts,
      'created_at': createdAt.toUtc().toIso8601String(),
      'next_retry_at': nextRetryAt?.toUtc().toIso8601String(),
      'last_error': lastError,
    };
  }

  /// Crea una instancia de PendingOperation a partir de
  /// un registro obtenido desde SQLite.
  factory PendingOperation.fromMap(Map<String, dynamic> map) {
    return PendingOperation(
      id: map['id'] as int?,
      operationId: map['operation_id'] as String,
      entityType: map['entity_type'] as String,
      operationType: map['operation_type'] as String,
      clientId: map['client_id'] as String,
      payload: _convertPayload(map['payload']),
      attempts: map['attempts'] as int? ?? 0,
      createdAt: DateTime.parse(
        map['created_at'] as String,
      ).toLocal(),
      nextRetryAt: map['next_retry_at'] != null
          ? DateTime.parse(
              map['next_retry_at'] as String,
            ).toLocal()
          : null,
      lastError: map['last_error'] as String?,
    );
  }

  /// Convierte el payload almacenado como JSON nuevamente
  // ignore: unintended_html_in_doc_comment
  /// en un Map'<String, dynamic>'.
  static Map<String, dynamic> _convertPayload(dynamic value) {
    if (value == null) {
      return {};
    }

    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is String) {
      final decoded = jsonDecode(value);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {};
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  /// Permite crear una copia modificada de la operación.
  ///
  /// Será útil cuando aumentemos los intentos o actualicemos
  /// el error durante la sincronización.
  PendingOperation copyWith({
    int? id,
    String? operationId,
    String? entityType,
    String? operationType,
    String? clientId,
    Map<String, dynamic>? payload,
    int? attempts,
    DateTime? createdAt,
    DateTime? nextRetryAt,
    String? lastError,
    bool clearNextRetryAt = false,
    bool clearLastError = false,
  }) {
    return PendingOperation(
      id: id ?? this.id,
      operationId: operationId ?? this.operationId,
      entityType: entityType ?? this.entityType,
      operationType: operationType ?? this.operationType,
      clientId: clientId ?? this.clientId,
      payload: payload ?? this.payload,
      attempts: attempts ?? this.attempts,
      createdAt: createdAt ?? this.createdAt,
      nextRetryAt: clearNextRetryAt
          ? null
          : nextRetryAt ?? this.nextRetryAt,
      lastError: clearLastError
          ? null
          : lastError ?? this.lastError,
    );
  }

  @override
  String toString() {
    return '''
PendingOperation(
  id: $id,
  operationId: $operationId,
  entityType: $entityType,
  operationType: $operationType,
  clientId: $clientId,
  attempts: $attempts,
  createdAt: $createdAt,
  nextRetryAt: $nextRetryAt,
  lastError: $lastError
)
''';
  }
}