using Microsoft.AspNetCore.Mvc;
using DentisAppAPI.Models;

namespace DentisAppAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PacientesController : ControllerBase
{
    private static readonly List<Paciente> Pacientes = new()
    {
        new Paciente
        {
            IdPaciente = 1,
            Nombre = "Juan",
            Apellido = "Pérez",
            Cedula = "1234567890",
            FechaNacimiento = new DateTime(1990, 1, 1),
            Telefono = "0991234567",
            Correo = "juan@gmail.com",
            Direccion = "Av. Quito"
        },
        new Paciente
        {
            IdPaciente = 2,
            Nombre = "María",
            Apellido = "Gómez",
            Cedula = "0987654321",
            FechaNacimiento = new DateTime(1992, 5, 15),
            Telefono = "0987654321",
            Correo = "maria@gmail.com",
            Direccion = "Av. Amazonas"
        }
    };

    [HttpGet]
    public ActionResult<IEnumerable<Paciente>> Get()
        => Ok(Pacientes);

    [HttpGet("{id}")]
    public ActionResult<Paciente> Get(int id)
    {
        var paciente = Pacientes.FirstOrDefault(p => p.IdPaciente == id);
        return paciente is null ? NotFound() : Ok(paciente);
    }

    [HttpPost]
    public ActionResult<Paciente> Post(Paciente paciente)
    {
        paciente.IdPaciente = Pacientes.Count + 1;
        Pacientes.Add(paciente);
        return CreatedAtAction(nameof(Get), new { id = paciente.IdPaciente }, paciente);
    }

    [HttpPut("{id}")]
    public ActionResult<Paciente> Put(int id, Paciente paciente)
    {
        var existing = Pacientes.FirstOrDefault(p => p.IdPaciente == id);
        if (existing is null) return NotFound();

        existing.Nombre = paciente.Nombre;
        existing.Apellido = paciente.Apellido;
        existing.Cedula = paciente.Cedula;
        existing.FechaNacimiento = paciente.FechaNacimiento;
        existing.Telefono = paciente.Telefono;
        existing.Correo = paciente.Correo;
        existing.Direccion = paciente.Direccion;

        return Ok(existing);
    }

    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        var paciente = Pacientes.FirstOrDefault(p => p.IdPaciente == id);
        if (paciente is null) return NotFound();

        Pacientes.Remove(paciente);
        return NoContent();
    }
}
