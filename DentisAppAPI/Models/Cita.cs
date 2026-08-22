using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

[Table("CITAS")]
public class Cita
{
    [Key]
    [Column("ID_CITA")]
    [JsonPropertyName("idCita")]
    public int IdCita { get; set; }

    [Required(ErrorMessage = "La fecha y hora de la cita son obligatorias.")]
    [Column("FECHA_HORA")]
    [JsonPropertyName("fechaHora")]
    public DateTime FechaHora { get; set; }

    [Required(ErrorMessage = "El motivo es obligatorio.")]
    [StringLength(200)]
    [Column("MOTIVO")]
    [JsonPropertyName("motivo")]
    public string Motivo { get; set; } = string.Empty;

    [Required(ErrorMessage = "El estado es obligatorio.")]
    [StringLength(15)]
    [RegularExpression(
        "Programada|Atendida|Cancelada|Reprogramada",
        ErrorMessage =
            "El estado debe ser Programada, Atendida, Cancelada o Reprogramada."
    )]
    [Column("ESTADO")]
    [JsonPropertyName("estado")]
    public string Estado { get; set; } = "Programada";

    [Required]
    [Column("ID_PACIENTE")]
    [JsonPropertyName("idPaciente")]
    public int IdPaciente { get; set; }

    [Required]
    [Column("ID_ODONTOLOGO")]
    [JsonPropertyName("idOdontologo")]
    public int IdOdontologo { get; set; }

    // Relaciones
    [ForeignKey(nameof(IdPaciente))]
    public Paciente? Paciente { get; set; }

    [ForeignKey(nameof(IdOdontologo))]
    public Odontologo? Odontologo { get; set; }

    public ICollection<Pago> Pagos { get; set; }
        = new List<Pago>();

    public ICollection<CitaTratamiento> CitaTratamientos { get; set; }
        = new List<CitaTratamiento>();
}