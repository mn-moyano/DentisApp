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

    [Required]
    [StringLength(100)]
    [Column("NOMBRES")]
    [JsonPropertyName("nombres")]
    public string Nombres { get; set; } = string.Empty;

    [Required]
    [StringLength(100)]
    [Column("APELLIDOS")]
    [JsonPropertyName("apellidos")]
    public string Apellidos { get; set; } = string.Empty;

    [Required]
    [StringLength(80)]
    [Column("ESPECIALIDAD")]
    [JsonPropertyName("especialidad")]
    public string Especialidad { get; set; } = string.Empty;

    [StringLength(15)]
    [Column("TELEFONO")]
    [JsonPropertyName("telefono")]
    public string? Telefono { get; set; }

    [StringLength(100)]
    [Column("CORREO")]
    [JsonPropertyName("correo")]
    public string? Correo { get; set; }

    [Column("ESTADO")]
    [JsonPropertyName("estado")]
    public string Estado { get; set; } = "Activo";
}