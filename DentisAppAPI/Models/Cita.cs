using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

/// Representa una cita agendada en el sistema odontológico.
public class Cita
{
    /// Identificador único de la cita.
    [JsonPropertyName("idCita")]
    public int? IdCita { get; set; }

    /// Fecha y hora de la cita.
    [JsonPropertyName("fecha")]
    public DateTime? Fecha { get; set; }

    /// Estado actual de la cita.
    [JsonPropertyName("estado")]
    public string? Estado { get; set; }

    /// Identificador del paciente asociado.
    [JsonPropertyName("idPaciente")]
    public int? IdPaciente { get; set; }

    /// Identificador del odontólogo asignado.
    [JsonPropertyName("idOdontologo")]
    public int? IdOdontologo { get; set; }

    /// Tratamientos asociados a la cita.
    [JsonIgnore]
    public ICollection<CitaTratamiento> Tratamientos { get; set; } = [];
}
