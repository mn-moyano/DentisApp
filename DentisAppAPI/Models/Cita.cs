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

    [Required(ErrorMessage = "La fecha de la cita es obligatoria.")]
    [Column("FECHA")]
    [JsonPropertyName("fecha")]
    public DateTime Fecha { get; set; }

    [Required(ErrorMessage = "El estado es obligatorio.")]
    [StringLength(20)]
    [RegularExpression("Programada|Atendida|Cancelada",
        ErrorMessage = "El estado debe ser Programada, Atendida o Cancelada.")]
    [Column("ESTADO")]
    [JsonPropertyName("estado")]
    public string Estado { get; set; } = string.Empty;

    [Required]
    [Column("ID_PACIENTE")]
    [JsonPropertyName("idPaciente")]
    public int IdPaciente { get; set; }

    [Required]
    [Column("ID_ODONTOLOGO")]
    [JsonPropertyName("idOdontologo")]
    public int IdOdontologo { get; set; }

    // ==========================
    // Propiedades de navegación
    // ==========================

    [ForeignKey(nameof(IdPaciente))]
    public Paciente? Paciente { get; set; }

    [ForeignKey(nameof(IdOdontologo))]
    public Odontologo? Odontologo { get; set; }

    public ICollection<Pago> Pagos { get; set; } = new List<Pago>();

    public ICollection<CitaTratamiento> CitaTratamientos { get; set; } = new List<CitaTratamiento>();
}