using Microsoft.AspNetCore.Mvc;
using DentisAppAPI.Models;

namespace DentisAppAPI.Controllers;

/// Controlador para gestionar las citas del sistema odontológico.
[ApiController]
[Route("api/[controller]")]
public class CitasController : ControllerBase
{
    // Lista en memoria para simular almacenamiento temporal.
    private static readonly List<Cita> Citas = new()
    {
        new Cita { IdCita = 1, Fecha = new DateTime(2026, 7, 20, 9, 0, 0), Estado = "Programada", IdPaciente = 1, IdOdontologo = 1 },
        new Cita { IdCita = 2, Fecha = new DateTime(2026, 7, 20, 10, 30, 0), Estado = "Atendida", IdPaciente = 2, IdOdontologo = 2 },
        new Cita { IdCita = 3, Fecha = new DateTime(2026, 7, 21, 14, 0, 0), Estado = "Cancelada", IdPaciente = 3, IdOdontologo = 1 }
    };

    /// Obtiene la lista de todas las citas registradas.
    [HttpGet]
    public ActionResult<IEnumerable<Cita>> Get() => Ok(Citas);

    /// Obtiene una cita por su identificador.
    [HttpGet("{id}")]
    public ActionResult<Cita> Get(int id)
    {
        var cita = Citas.FirstOrDefault(c => c.IdCita == id);
        return cita is null ? NotFound() : Ok(cita);
    }

    /// Crea una nueva cita.
    [HttpPost]
    public ActionResult<Cita> Post(Cita cita)
    {
        cita.IdCita = Citas.Count + 1;
        Citas.Add(cita);
        return CreatedAtAction(nameof(Get), new { id = cita.IdCita }, cita);
    }

    /// Actualiza una cita existente.
    [HttpPut("{id}")]
    public ActionResult<Cita> Put(int id, Cita cita)
    {
        var existing = Citas.FirstOrDefault(c => c.IdCita == id);
        if (existing is null) return NotFound();

        existing.Fecha = cita.Fecha;
        existing.Estado = cita.Estado;
        existing.IdPaciente = cita.IdPaciente;
        existing.IdOdontologo = cita.IdOdontologo;

        return Ok(existing);
    }

    /// Elimina una cita por su identificador.
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        var cita = Citas.FirstOrDefault(c => c.IdCita == id);
        if (cita is null) return NotFound();

        Citas.Remove(cita);
        return NoContent();
    }
}
