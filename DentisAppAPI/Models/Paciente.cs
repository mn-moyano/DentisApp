using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

public class Paciente
{
    [JsonPropertyName("idPaciente")]
    public int? IdPaciente { get; set; }

    [JsonPropertyName("nombre")]
    public string? Nombre { get; set; }

    [JsonPropertyName("apellido")]
    public string? Apellido { get; set; }

    [JsonPropertyName("cedula")]
    public string? Cedula { get; set; }

    [JsonPropertyName("fechaNacimiento")]
    public DateTime? FechaNacimiento { get; set; }

    [JsonPropertyName("telefono")]
    public string? Telefono { get; set; }

    [JsonPropertyName("correo")]
    public string? Correo { get; set; }

    [JsonPropertyName("direccion")]
    public string? Direccion { get; set; }
}
