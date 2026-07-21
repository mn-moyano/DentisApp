using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DentisAppAPI.Models;

[Table("PACIENTES")]
public class Paciente
{
    [Key]
    [Column("ID_PACIENTE")]
    public int IdPaciente { get; set; }

    [Required(ErrorMessage = "Los nombres son obligatorios.")]
    [StringLength(60)]
    [Column("NOMBRES")]
    public string Nombres { get; set; } = string.Empty;

    [Required(ErrorMessage = "Los apellidos son obligatorios.")]
    [StringLength(60)]
    [Column("APELLIDOS")]
    public string Apellidos { get; set; } = string.Empty;

    [Required(ErrorMessage = "La cédula es obligatoria.")]
    [StringLength(10, MinimumLength = 10)]
    [RegularExpression(@"^\d{10}$",
        ErrorMessage = "La cédula debe contener exactamente 10 dígitos.")]
    [Column("CEDULA")]
    public string Cedula { get; set; } = string.Empty;

    [Column("FECHA_NACIMIENTO")]
    public DateTime? FechaNacimiento { get; set; }

    [Phone]
    [StringLength(15)]
    [Column("TELEFONO")]
    public string? Telefono { get; set; }

    [EmailAddress(ErrorMessage = "Correo electrónico no válido.")]
    [StringLength(100)]
    [Column("CORREO")]
    public string? Correo { get; set; }

    [StringLength(150)]
    [Column("DIRECCION")]
    public string? Direccion { get; set; }
}