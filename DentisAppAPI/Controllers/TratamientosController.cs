using Microsoft.AspNetCore.Mvc;
using DentisAppAPI.Models;

namespace DentisAppAPI.Controllers;

/// Controlador para gestionar los tratamientos odontológicos.
[ApiController]
[Route("api/[controller]")]
public class TratamientosController : ControllerBase
{
    // Lista en memoria para simular almacenamiento temporal.
    private static readonly List<Tratamiento> Tratamientos = new()
    {
        new Tratamiento { IdTratamiento = 1, Descripcion = "Limpieza dental", Costo = 35 },
        new Tratamiento { IdTratamiento = 2, Descripcion = "Resina dental", Costo = 60 },
        new Tratamiento { IdTratamiento = 3, Descripcion = "Extracción dental", Costo = 80 }
    };

    /// Obtiene la lista de todos los tratamientos.
    [HttpGet]
    public ActionResult<IEnumerable<Tratamiento>> Get() => Ok(Tratamientos);

    /// Obtiene un tratamiento por su identificador.
    [HttpGet("{id}")]
    public ActionResult<Tratamiento> Get(int id)
    {
        var tratamiento = Tratamientos.FirstOrDefault(t => t.IdTratamiento == id);
        return tratamiento is null ? NotFound() : Ok(tratamiento);
    }

    /// Crea un nuevo tratamiento.
    [HttpPost]
    public ActionResult<Tratamiento> Post(Tratamiento tratamiento)
    {
        tratamiento.IdTratamiento = Tratamientos.Count + 1;
        Tratamientos.Add(tratamiento);
        return CreatedAtAction(nameof(Get), new { id = tratamiento.IdTratamiento }, tratamiento);
    }

    /// Actualiza un tratamiento existente.
    [HttpPut("{id}")]
    public ActionResult<Tratamiento> Put(int id, Tratamiento tratamiento)
    {
        var existing = Tratamientos.FirstOrDefault(t => t.IdTratamiento == id);
        if (existing is null) return NotFound();

        existing.Descripcion = tratamiento.Descripcion;
        existing.Costo = tratamiento.Costo;

        return Ok(existing);
    }

    /// Elimina un tratamiento por su identificador.
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        var tratamiento = Tratamientos.FirstOrDefault(t => t.IdTratamiento == id);
        if (tratamiento is null) return NotFound();

        Tratamientos.Remove(tratamiento);
        return NoContent();
    }
}
