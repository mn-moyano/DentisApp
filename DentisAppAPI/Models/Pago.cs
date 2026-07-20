using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

[Table("PAGOS")]
public class Pago
{
    [Key]
    [Column("ID_PAGO")]
    [JsonPropertyName("idPago")]
    public int IdPago { get; set; }

    [Column("ID_CITA")]
    [JsonPropertyName("idCita")]
    public int IdCita { get; set; }

    [Column("MONTO")]
    [JsonPropertyName("monto")]
    public decimal Monto { get; set; }

    [Column("FECHA_PAGO")]
    [JsonPropertyName("fechaPago")]
    public DateTime FechaPago { get; set; }

    [Required]
    [StringLength(30)]
    [Column("METODO_PAGO")]
    [JsonPropertyName("metodoPago")]
    public string MetodoPago { get; set; } = string.Empty;
}