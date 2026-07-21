using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace DentisAppAPI.Models;

[Table("TRATAMIENTOS")]
public class Tratamiento
{
    [Key]
    [Column("ID_TRATAMIENTO")]
    [JsonPropertyName("idTratamiento")]
    public int IdTratamiento { get; set; }

    [Required(ErrorMessage = "El tipo de tratamiento es obligatorio.")]
    [StringLength(100)]
    [Column("TIPO_TRATAMIENTO")]
    [JsonPropertyName("tipoTratamiento")]
    public string TipoTratamiento { get; set; } = string.Empty;

    [StringLength(300)]
    [Column("DESCRIPCION")]
    [JsonPropertyName("descripcion")]
    public string? Descripcion { get; set; }

    [Required(ErrorMessage = "El costo es obligatorio.")]
    [Range(0.01, 100000,
        ErrorMessage = "El costo debe ser mayor que cero.")]
    [Column("COSTO", TypeName = "NUMBER(10,2)")]
    [JsonPropertyName("costo")]
    public decimal Costo { get; set; }

    //==========================
    // Propiedad de navegación
    //==========================

    public ICollection<CitaTratamiento> CitaTratamientos { get; set; }
        = new List<CitaTratamiento>();
}