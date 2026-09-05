using System.ComponentModel.DataAnnotations;

namespace DentisAppAPI.DTOs.Paciente;

public class PacienteRequest
{
    [Required(ErrorMessage = "Los nombres son obligatorios.")]
    [StringLength(60)]
    public string Nombres { get; set; } = string.Empty;

    [Required(ErrorMessage = "Los apellidos son obligatorios.")]
    [StringLength(60)]
    public string Apellidos { get; set; } = string.Empty;

    [Required(ErrorMessage = "La cédula es obligatoria.")]
    [StringLength(10, MinimumLength = 10)]
    [RegularExpression(@"^\d{10}$",
        ErrorMessage = "La cédula debe contener exactamente 10 dígitos.")]
    public string Cedula { get; set; } = string.Empty;

    public DateTime? FechaNacimiento { get; set; }

    [Phone]
    [StringLength(15)]
    public string? Telefono { get; set; }

    [EmailAddress(ErrorMessage = "Correo electrónico no válido.")]
    [StringLength(100)]
    public string? Correo { get; set; }

    [StringLength(150)]
    public string? Direccion { get; set; }
}
