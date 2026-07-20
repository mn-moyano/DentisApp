using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

[Table("CITA_TRATAMIENTO")]
public class CitaTratamiento
{
    [Column("ID_CITA")]
    [JsonPropertyName("idCita")]
    public int CitaId { get; set; }

    [Column("ID_TRATAMIENTO")]
    [JsonPropertyName("idTratamiento")]
    public int TratamientoId { get; set; }

    [Column("CANTIDAD")]
    [JsonPropertyName("cantidad")]
    public int Cantidad { get; set; }
}