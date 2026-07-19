using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

/// Representa la asociación entre una cita y un tratamiento.
public class CitaTratamiento
{
    /// Identificador de la cita asociada.
    [JsonPropertyName("idCita")]
    public int? CitaId { get; set; }

    /// Identificador del tratamiento asociado.
    [JsonPropertyName("idTratamiento")]
    public int? TratamientoId { get; set; }

    /// Referencia de navegación a la cita relacionada.
    [JsonIgnore]
    public Cita? Cita { get; set; }

    /// Referencia de navegación al tratamiento relacionado.
    [JsonIgnore]
    public Tratamiento? Tratamiento { get; set; }
}
