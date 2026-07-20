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

    [Column("FECHA")]
    [JsonPropertyName("fecha")]
    public DateTime Fecha { get; set; }

    [Required]
    [StringLength(20)]
    [Column("ESTADO")]
    [JsonPropertyName("estado")]
    public string Estado { get; set; } = string.Empty;

    [Column("ID_PACIENTE")]
    [JsonPropertyName("idPaciente")]
    public int IdPaciente { get; set; }

    [Column("ID_ODONTOLOGO")]
    [JsonPropertyName("idOdontologo")]
    public int IdOdontologo { get; set; }
}