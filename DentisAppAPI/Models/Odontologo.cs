using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

[Table("ODONTOLOGOS")]
public class Odontologo
{
    [Key]
    [Column("ID_ODONTOLOGO")]
    [JsonPropertyName("idOdontologo")]
    public int IdOdontologo { get; set; }

    [Required(ErrorMessage = "Los nombres son obligatorios.")]
    [StringLength(60)]
    [Column("NOMBRES")]
    [JsonPropertyName("nombres")]
    public string Nombres { get; set; } = string.Empty;

    [Required(ErrorMessage = "Los apellidos son obligatorios.")]
    [StringLength(60)]
    [Column("APELLIDOS")]
    [JsonPropertyName("apellidos")]
    public string Apellidos { get; set; } = string.Empty;

    [Required(ErrorMessage = "La especialidad es obligatoria.")]
    [StringLength(80)]
    [Column("ESPECIALIDAD")]
    [JsonPropertyName("especialidad")]
    public string Especialidad { get; set; } = string.Empty;

    [Phone(ErrorMessage = "El teléfono no es válido.")]
    [StringLength(15)]
    [Column("TELEFONO")]
    [JsonPropertyName("telefono")]
    public string? Telefono { get; set; }

    [EmailAddress(ErrorMessage = "El correo electrónico no es válido.")]
    [StringLength(100)]
    [Column("CORREO")]
    [JsonPropertyName("correo")]
    public string? Correo { get; set; }

    [Required]
    [RegularExpression("Activo|Inactivo",
        ErrorMessage = "El estado solo puede ser Activo o Inactivo.")]
    [Column("ESTADO")]
    [JsonPropertyName("estado")]
    public string Estado { get; set; } = "Activo";
}