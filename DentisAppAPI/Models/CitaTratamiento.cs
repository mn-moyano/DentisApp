using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

/// Representa la asociación entre una cita y un tratamiento.
public class CitaTratamiento
{
    /// Identificador de la cita asociada.
    [JsonPropertyName("idCita")]
    public int? IdCita { get; set; }

    /// Identificador del tratamiento asociado.
    [JsonPropertyName("idTratamiento")]
    public int? IdTratamiento { get; set; }
}
