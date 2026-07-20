using DentisAppAPI.Data;
using DentisAppAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DentisAppAPI.Controllers;

/// Controlador encargado de gestionar las operaciones relacionadas con los pacientes.
[ApiController]
[Route("api/[controller]")]
public class PacientesController : ControllerBase
{
    private readonly DentisAppContext _context;

    public PacientesController(DentisAppContext context)
    {
        _context = context;
    }

    /// Obtiene la lista completa de pacientes registrados.
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Paciente>>> Get()
    {
        var pacientes = await _context.Pacientes
            .OrderBy(p => p.IdPaciente)
            .ToListAsync();

        return Ok(pacientes);
    }

    /// Obtiene un paciente según su identificador.
    [HttpGet("{id}")]
    public async Task<ActionResult<Paciente>> Get(int id)
    {
        var paciente = await _context.Pacientes.FindAsync(id);
        return paciente is null ? NotFound() : Ok(paciente);
    }

    /// Verifica si la API puede conectarse a la base de datos.
    [HttpGet("health")]
    public async Task<IActionResult> Health()
    {
        try
        {
            await _context.Database.OpenConnectionAsync();
            await _context.Database.CloseConnectionAsync();
            return Ok(new { connected = true, message = "Conexión OK" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { connected = false, error = ex.Message });
        }
    }

    /// Crea un nuevo paciente y lo guarda en la base de datos.
    [HttpPost]
    public async Task<ActionResult<Paciente>> Post(Paciente paciente)
    {
        _context.Pacientes.Add(paciente);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(Get), new { id = paciente.IdPaciente }, paciente);
    }

    /// Actualiza los datos de un paciente existente.
    [HttpPut("{id}")]
    public async Task<IActionResult> Put(int id, Paciente paciente)
    {
        var existing = await _context.Pacientes.FindAsync(id);
        if (existing is null) return NotFound();

        existing.Nombre = paciente.Nombre;
        existing.Apellido = paciente.Apellido;
        existing.Cedula = paciente.Cedula;
        existing.FechaNacimiento = paciente.FechaNacimiento;
        existing.Telefono = paciente.Telefono;
        existing.Correo = paciente.Correo;
        existing.Direccion = paciente.Direccion;

        await _context.SaveChangesAsync();

        return Ok(existing);
    }

    /// Elimina un paciente registrado por su identificador.
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var paciente = await _context.Pacientes.FindAsync(id);
        if (paciente is null) return NotFound();

        _context.Pacientes.Remove(paciente);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
