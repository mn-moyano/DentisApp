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

    [Required]
    [StringLength(100)]
    [Column("TIPO_TRATAMIENTO")]
    [JsonPropertyName("tipoTratamiento")]
    public string TipoTratamiento { get; set; } = string.Empty;

    [StringLength(300)]
    [Column("DESCRIPCION")]
    [JsonPropertyName("descripcion")]
    public string? Descripcion { get; set; }

    [Column("COSTO")]
    [JsonPropertyName("costo")]
    public decimal Costo { get; set; }
}