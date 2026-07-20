using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

/// Representa a un paciente dentro del sistema odontológico.
public class Paciente
{
    /// Identificador único del paciente.
    [Key]
    [JsonPropertyName("idPaciente")]
    public int IdPaciente { get; set; }

    /// Nombre del paciente.
    [JsonPropertyName("nombre")]
    public string? Nombre { get; set; }

    /// Apellido del paciente.
    [JsonPropertyName("apellido")]
    public string? Apellido { get; set; }

    /// Número de cédula del paciente.
    [JsonPropertyName("cedula")]
    public string? Cedula { get; set; }

    /// Fecha de nacimiento del paciente.
    [JsonPropertyName("fechaNacimiento")]
    public DateTime? FechaNacimiento { get; set; }

    /// Número de teléfono de contacto.
    [JsonPropertyName("telefono")]
    public string? Telefono { get; set; }

    /// Correo electrónico del paciente.
    [JsonPropertyName("correo")]
    public string? Correo { get; set; }

    /// Dirección de domicilio del paciente.
    [JsonPropertyName("direccion")]
    public string? Direccion { get; set; }
}
