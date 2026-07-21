using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

[Table("CITA_TRATAMIENTO")]
public class CitaTratamiento
{
    [Required]
    [Column("ID_CITA")]
    [JsonPropertyName("idCita")]
    public int CitaId { get; set; }

    [Required]
    [Column("ID_TRATAMIENTO")]
    [JsonPropertyName("idTratamiento")]
    public int TratamientoId { get; set; }

    [Required]
    [Range(1, 100, ErrorMessage = "La cantidad debe ser mayor a cero.")]
    [Column("CANTIDAD")]
    [JsonPropertyName("cantidad")]
    public int Cantidad { get; set; }

    //==========================
    // Propiedades de navegación
    //==========================

    [ForeignKey(nameof(CitaId))]
    public Cita? Cita { get; set; }

    [ForeignKey(nameof(TratamientoId))]
    public Tratamiento? Tratamiento { get; set; }
}