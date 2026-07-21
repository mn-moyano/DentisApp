using DentisAppAPI.Data;
using DentisAppAPI.Helpers;
using DentisAppAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;

namespace DentisAppAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PacientesController : ControllerBase
    {
        private readonly DentisAppContext _context;
        private readonly IMemoryCache _cache;
        private readonly ILogger<PacientesController> _logger;

        public PacientesController(
            DentisAppContext context,
            IMemoryCache cache,
            ILogger<PacientesController> logger)
        {
            _context = context;
            _cache = cache;
            _logger = logger;
        }

        /// <summary>
        /// Obtiene todos los pacientes utilizando caché (Cache Aside).
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetPacientes()
        {
            try
            {
                const string cacheKey = "PACIENTES_CACHE";

                if (!_cache.TryGetValue(cacheKey, out List<Paciente>? pacientes))
                {
                    pacientes = await _context.Pacientes
                        .AsNoTracking()
                        .OrderBy(p => p.Nombres)
                        .ToListAsync();

                    var opciones = new MemoryCacheEntryOptions()
                        .SetAbsoluteExpiration(TimeSpan.FromMinutes(5));

                    _cache.Set(cacheKey, pacientes, opciones);

                    _logger.LogInformation("Pacientes obtenidos desde Oracle.");
                }
                else
                {
                    _logger.LogInformation("Pacientes obtenidos desde la memoria caché.");
                }

                return Ok(new ApiResponse<List<Paciente>>
                {
                    Success = true,
                    Message = "Listado de pacientes obtenido correctamente.",
                    Data = pacientes
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al listar pacientes.");

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Ocurrió un error interno del servidor."
                });
            }
        }

        /// <summary>
        /// Obtiene un paciente por su ID.
        /// </summary>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetPaciente(int id)
        {
            try
            {
                var paciente = await _context.Pacientes
                    .AsNoTracking()
                    .FirstOrDefaultAsync(p => p.IdPaciente == id);

                if (paciente == null)
                {
                    return NotFound(new ApiError
                    {
                        StatusCode = 404,
                        Timestamp = DateTime.Now,
                        Message = "Paciente no encontrado."
                    });
                }

                return Ok(new ApiResponse<Paciente>
                {
                    Success = true,
                    Message = "Paciente obtenido correctamente.",
                    Data = paciente
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al buscar paciente.");

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Ocurrió un error interno del servidor."
                });
            }
        }

        /// <summary>
        /// Lista pacientes con paginación.
        /// </summary>
        [HttpGet("paginado")]
        public async Task<IActionResult> GetPacientesPaginado(
            int page = 1,
            int pageSize = 10)
        {
            try
            {
                if (page < 1)
                    page = 1;

                if (pageSize < 1)
                    pageSize = 10;

                if (pageSize > 50)
                    pageSize = 50;

                var totalRegistros = await _context.Pacientes.CountAsync();

                var pacientes = await _context.Pacientes
                    .AsNoTracking()
                    .OrderBy(p => p.Nombres)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToListAsync();

                return Ok(new
                {
                    success = true,
                    message = "Listado de pacientes obtenido correctamente.",
                    pagination = new
                    {
                        page,
                        pageSize,
                        totalRecords = totalRegistros,
                        totalPages = (int)Math.Ceiling((double)totalRegistros / pageSize)
                    },
                    data = pacientes
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error en paginación.");

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Ocurrió un error interno del servidor."
                });
            }
        }
                /// <summary>
        /// Registra un nuevo paciente.
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> PostPaciente(Paciente paciente)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                if (paciente == null)
                {
                    return BadRequest(new ApiError
                    {
                        StatusCode = 400,
                        Timestamp = DateTime.Now,
                        Message = "Los datos enviados son inválidos."
                    });
                }

                bool cedulaExiste = await _context.Pacientes
                    .AnyAsync(p => p.Cedula == paciente.Cedula);

                if (cedulaExiste)
                {
                    return Conflict(new ApiError
                    {
                        StatusCode = 409,
                        Timestamp = DateTime.Now,
                        Message = "La cédula ya se encuentra registrada."
                    });
                }

                bool correoExiste = await _context.Pacientes
                    .AnyAsync(p => p.Correo == paciente.Correo);

                if (correoExiste)
                {
                    return Conflict(new ApiError
                    {
                        StatusCode = 409,
                        Timestamp = DateTime.Now,
                        Message = "El correo ya se encuentra registrado."
                    });
                }

                _context.Pacientes.Add(paciente);

                await _context.SaveChangesAsync();

                _cache.Remove("PACIENTES_CACHE");

                _logger.LogInformation(
                    "Paciente {Paciente} registrado correctamente.",
                    paciente.Nombres);

                return CreatedAtAction(
                    nameof(GetPaciente),
                    new { id = paciente.IdPaciente },
                    new ApiResponse<Paciente>
                    {
                        Success = true,
                        Message = "Paciente registrado correctamente.",
                        Data = paciente
                    });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al registrar paciente.");

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Ocurrió un error interno del servidor."
                });
            }
        }
                /// <summary>
        /// Actualiza la información de un paciente.
        /// </summary>
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPaciente(int id, Paciente paciente)
        {
            try
            {
                if (id != paciente.IdPaciente)
                {
                    return BadRequest(new ApiError
                    {
                        StatusCode = 400,
                        Timestamp = DateTime.Now,
                        Message = "El ID enviado no coincide con el paciente."
                    });
                }

                var pacienteExistente = await _context.Pacientes
                    .FirstOrDefaultAsync(p => p.IdPaciente == id);

                if (pacienteExistente == null)
                {
                    return NotFound(new ApiError
                    {
                        StatusCode = 404,
                        Timestamp = DateTime.Now,
                        Message = "Paciente no encontrado."
                    });
                }

                bool cedulaDuplicada = await _context.Pacientes
                    .AnyAsync(p =>
                        p.Cedula == paciente.Cedula &&
                        p.IdPaciente != id);

                if (cedulaDuplicada)
                {
                    return Conflict(new ApiError
                    {
                        StatusCode = 409,
                        Timestamp = DateTime.Now,
                        Message = "La cédula pertenece a otro paciente."
                    });
                }

                bool correoDuplicado = await _context.Pacientes
                    .AnyAsync(p =>
                        p.Correo == paciente.Correo &&
                        p.IdPaciente != id);

                if (correoDuplicado)
                {
                    return Conflict(new ApiError
                    {
                        StatusCode = 409,
                        Timestamp = DateTime.Now,
                        Message = "El correo pertenece a otro paciente."
                    });
                }

                // Actualizar únicamente los campos editables
                pacienteExistente.Nombres = paciente.Nombres;
                pacienteExistente.Apellidos = paciente.Apellidos;
                pacienteExistente.Cedula = paciente.Cedula;
                pacienteExistente.FechaNacimiento = paciente.FechaNacimiento;
                pacienteExistente.Telefono = paciente.Telefono;
                pacienteExistente.Correo = paciente.Correo;
                pacienteExistente.Direccion = paciente.Direccion;

                await _context.SaveChangesAsync();

                // Invalidar caché
                _cache.Remove("PACIENTES_CACHE");

                _logger.LogInformation(
                    "Paciente con ID {IdPaciente} actualizado correctamente.",
                    id);

                return Ok(new ApiResponse<Paciente>
                {
                    Success = true,
                    Message = "Paciente actualizado correctamente.",
                    Data = pacienteExistente
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,
                    "Error al actualizar el paciente con ID {IdPaciente}.",
                    id);

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Ocurrió un error interno del servidor."
                });
            }
        }
                /// <summary>
        /// Elimina un paciente.
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePaciente(int id)
        {
            try
            {
                var paciente = await _context.Pacientes
                    .FirstOrDefaultAsync(p => p.IdPaciente == id);

                if (paciente == null)
                {
                    return NotFound(new ApiError
                    {
                        StatusCode = 404,
                        Timestamp = DateTime.Now,
                        Message = "Paciente no encontrado."
                    });
                }

                _context.Pacientes.Remove(paciente);

                await _context.SaveChangesAsync();

                // Invalidar caché
                _cache.Remove("PACIENTES_CACHE");

                _logger.LogInformation(
                    "Paciente con ID {IdPaciente} eliminado correctamente.",
                    id);

                return Ok(new ApiResponse<string>
                {
                    Success = true,
                    Message = "Paciente eliminado correctamente.",
                    Data = $"Paciente con ID {id} eliminado."
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,
                    "Error al eliminar el paciente con ID {IdPaciente}.",
                    id);

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Ocurrió un error interno del servidor."
                });
            }
        }
    }
}