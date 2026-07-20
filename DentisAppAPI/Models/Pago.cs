using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

/// Representa un pago registrado para una cita.
public class Pago
{
    /// Identificador único del pago.
    [Key]
    [JsonPropertyName("idPago")]
    public int IdPago { get; set; }

    /// Fecha en la que se realizó el pago.
    [JsonPropertyName("fechaPago")]
    public DateTime? FechaPago { get; set; }

    /// Monto pagado.
    [JsonPropertyName("monto")]
    public decimal? Monto { get; set; }

    /// Método de pago utilizado.
    [JsonPropertyName("metodoPago")]
    public string? MetodoPago { get; set; }

    /// Identificador de la cita relacionada.
    [JsonPropertyName("idCita")]
    public int? IdCita { get; set; }
}
