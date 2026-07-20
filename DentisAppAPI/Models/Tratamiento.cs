using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

/// Representa un tratamiento odontológico ofrecido por la clínica.
public class Tratamiento
{
    /// Identificador único del tratamiento.
    [Key]
    [JsonPropertyName("idTratamiento")]
    public int IdTratamiento { get; set; }

    /// Descripción del tratamiento.
    [JsonPropertyName("descripcion")]
    public string? Descripcion { get; set; }

    /// Costo del tratamiento.
    [JsonPropertyName("costo")]
    public decimal? Costo { get; set; }

    /// Citas que incluyen este tratamiento.
    [JsonIgnore]
    public ICollection<CitaTratamiento> Citas { get; set; } = [];
}
