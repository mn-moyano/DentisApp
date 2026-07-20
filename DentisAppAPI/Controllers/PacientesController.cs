using DentisAppAPI.Models;
using DentisAppAPI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace DentisAppAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PacientesController : ControllerBase
    {
        private readonly PacienteService _service;

        public PacientesController(PacienteService service)
        {
            _service = service;
        }

        [HttpGet]
        public IActionResult Get()
        {
            var pacientes = _service.ObtenerPacientes();
            return Ok(pacientes);
        }

        [HttpPost]
        public IActionResult Post([FromBody] Paciente paciente)
        {
            _service.CrearPaciente(paciente);
            return CreatedAtAction(nameof(Get), new { id = paciente.IdPaciente }, paciente);
        }

        [HttpPut("{id}")]
        public IActionResult Put(int id, [FromBody] Paciente paciente)
        {
            paciente.IdPaciente = id;
            _service.ActualizarPaciente(paciente);
            return Ok(paciente);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            _service.EliminarPaciente(id);
            return Ok();
        }
    }
}
