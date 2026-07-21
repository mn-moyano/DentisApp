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

    [Required]
    [Column("ID_CITA")]
    [JsonPropertyName("idCita")]
    public int IdCita { get; set; }

    [Required(ErrorMessage = "El monto es obligatorio.")]
    [Range(0.01, 100000,
        ErrorMessage = "El monto debe ser mayor que cero.")]
    [Column("MONTO", TypeName = "NUMBER(10,2)")]
    [JsonPropertyName("monto")]
    public decimal Monto { get; set; }

    [Required(ErrorMessage = "La fecha de pago es obligatoria.")]
    [Column("FECHA_PAGO")]
    [JsonPropertyName("fechaPago")]
    public DateTime FechaPago { get; set; }

    [Required(ErrorMessage = "El método de pago es obligatorio.")]
    [StringLength(30)]
    [RegularExpression("Efectivo|Tarjeta|Transferencia",
        ErrorMessage = "El método de pago debe ser Efectivo, Tarjeta o Transferencia.")]
    [Column("METODO_PAGO")]
    [JsonPropertyName("metodoPago")]
    public string MetodoPago { get; set; } = string.Empty;

    //==========================
    // Propiedad de navegación
    //==========================

    [ForeignKey(nameof(IdCita))]
    public Cita? Cita { get; set; }
}