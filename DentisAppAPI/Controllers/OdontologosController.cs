using Microsoft.AspNetCore.Mvc;
using DentisAppAPI.Models;

namespace DentisAppAPI.Controllers;

/// Controlador para gestionar los odontólogos del sistema.
[ApiController]
[Route("api/[controller]")]
public class OdontologosController : ControllerBase
{
    // Lista en memoria para simular almacenamiento temporal.
    private static readonly List<Odontologo> Odontologos = new()
    {
        new Odontologo { IdOdontologo = 1, Nombre = "Dr. Andrés Morales", Especialidad = "Ortodoncia", Telefono = "0991111111", Correo = "amorales@dentisapp.com", Estado = "Activo" },
        new Odontologo { IdOdontologo = 2, Nombre = "Dra. María López", Especialidad = "Endodoncia", Telefono = "0992222222", Correo = "mlopez@dentisapp.com", Estado = "Activo" },
        new Odontologo { IdOdontologo = 3, Nombre = "Dr. Carlos Sánchez", Especialidad = "Odontología General", Telefono = "0993333333", Correo = "csanchez@dentisapp.com", Estado = "Inactivo" }
    };

    /// Obtiene la lista de todos los odontólogos.
    [HttpGet]
    public ActionResult<IEnumerable<Odontologo>> Get() => Ok(Odontologos);

    /// Obtiene un odontólogo por su identificador.
    [HttpGet("{id}")]
    public ActionResult<Odontologo> Get(int id)
    {
        var odontologo = Odontologos.FirstOrDefault(o => o.IdOdontologo == id);
        return odontologo is null ? NotFound() : Ok(odontologo);
    }

    /// Crea un nuevo odontólogo.
    [HttpPost]
    public ActionResult<Odontologo> Post(Odontologo odontologo)
    {
        odontologo.IdOdontologo = Odontologos.Count + 1;
        Odontologos.Add(odontologo);
        return CreatedAtAction(nameof(Get), new { id = odontologo.IdOdontologo }, odontologo);
    }

    /// Actualiza un odontólogo existente.
    [HttpPut("{id}")]
    public ActionResult<Odontologo> Put(int id, Odontologo odontologo)
    {
        var existing = Odontologos.FirstOrDefault(o => o.IdOdontologo == id);
        if (existing is null) return NotFound();

        existing.Nombre = odontologo.Nombre;
        existing.Especialidad = odontologo.Especialidad;
        existing.Telefono = odontologo.Telefono;
        existing.Correo = odontologo.Correo;
        existing.Estado = odontologo.Estado;

        return Ok(existing);
    }

    /// Elimina un odontólogo por su identificador.
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        var odontologo = Odontologos.FirstOrDefault(o => o.IdOdontologo == id);
        if (odontologo is null) return NotFound();

        Odontologos.Remove(odontologo);
        return NoContent();
    }
}
