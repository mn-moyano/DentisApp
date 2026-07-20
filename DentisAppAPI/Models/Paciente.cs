using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

[Table("PACIENTES")]
public class Paciente
{
    [Key]
    [Column("ID_PACIENTE")]
    public int IdPaciente { get; set; }

    [Column("NOMBRES")]
    public string Nombres { get; set; } = string.Empty;

    [Column("APELLIDOS")]
    public string Apellidos { get; set; } = string.Empty;

    [Column("CEDULA")]
    public string Cedula { get; set; } = string.Empty;

    [Column("FECHA_NACIMIENTO")]
    public DateTime? FechaNacimiento { get; set; }

    [Column("TELEFONO")]
    public string? Telefono { get; set; }

    [Column("CORREO")]
    public string? Correo { get; set; }

    [Column("DIRECCION")]
    public string? Direccion { get; set; }
}