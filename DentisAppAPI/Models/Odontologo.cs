using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

/// Representa a un odontólogo registrado en el sistema.
public class Odontologo
{
    /// Identificador único del odontólogo.
    [Key]
    [JsonPropertyName("idOdontologo")]
    public int IdOdontologo { get; set; }

    /// Nombre completo del profesional.
    [JsonPropertyName("nombre")]
    public string? Nombre { get; set; }

    /// Especialidad del odontólogo.
    [JsonPropertyName("especialidad")]
    public string? Especialidad { get; set; }

    /// Teléfono de contacto.
    [JsonPropertyName("telefono")]
    public string? Telefono { get; set; }

    /// Correo electrónico.
    [JsonPropertyName("correo")]
    public string? Correo { get; set; }

    /// Estado actual del odontólogo.
    [JsonPropertyName("estado")]
    public string? Estado { get; set; }
}
