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
    public class CitasController : ControllerBase
    {
        private readonly DentisAppContext _context;
        private readonly IMemoryCache _cache;
        private readonly ILogger<CitasController> _logger;

        public CitasController(
            DentisAppContext context,
            IMemoryCache cache,
            ILogger<CitasController> logger)
        {
            _context = context;
            _cache = cache;
            _logger = logger;
        }

        //=================================================
        // GET: api/citas
        //=================================================
        [HttpGet]
        public async Task<IActionResult> GetCitas()
        {
            try
            {
                const string cacheKey = "CITAS_CACHE";

                if (!_cache.TryGetValue(cacheKey, out List<Cita>? citas))
                {
                    citas = await _context.Citas
                        .Include(c => c.Paciente)
                        .Include(c => c.Odontologo)
                        .AsNoTracking()
                        .OrderBy(c => c.Fecha)
                        .ToListAsync();

                    _cache.Set(
                        cacheKey,
                        citas,
                        new MemoryCacheEntryOptions()
                            .SetAbsoluteExpiration(TimeSpan.FromMinutes(5)));

                    _logger.LogInformation("Citas obtenidas desde Oracle.");
                }
                else
                {
                    _logger.LogInformation("Citas obtenidas desde caché.");
                }

                return Ok(new ApiResponse<List<Cita>>
                {
                    Success = true,
                    Message = "Listado obtenido correctamente.",
                    Data = citas
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al listar citas.");

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Error interno del servidor."
                });
            }
        }

        //=================================================
        // GET: api/citas/5
        //=================================================
        [HttpGet("{id}")]
        public async Task<IActionResult> GetCita(int id)
        {
            try
            {
                var cita = await _context.Citas
                    .Include(c => c.Paciente)
                    .Include(c => c.Odontologo)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(c => c.IdCita == id);

                if (cita == null)
                {
                    return NotFound(new ApiError
                    {
                        StatusCode = 404,
                        Timestamp = DateTime.Now,
                        Message = "Cita no encontrada."
                    });
                }

                return Ok(new ApiResponse<Cita>
                {
                    Success = true,
                    Message = "Cita obtenida correctamente.",
                    Data = cita
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al consultar cita.");

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Error interno del servidor."
                });
            }
        }
        //=================================================
        // GET: Paginado
        //=================================================
        [HttpGet("paginado")]
        public async Task<IActionResult> GetCitasPaginado(int page = 1, int pageSize = 10)
        {
        try
        {
            if (page < 1) page = 1;
            if (pageSize < 1) pageSize = 10;
            if (pageSize > 50) pageSize = 50;

            int total = await _context.Citas.CountAsync();

            var citas = await _context.Citas
                .Include(c => c.Paciente)
                .Include(c => c.Odontologo)
                .AsNoTracking()
                .OrderBy(c => c.Fecha)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return Ok(new
            {
                success = true,
                message = "Listado obtenido correctamente.",
                pagination = new
                {
                    page,
                    pageSize,
                    totalRecords = total,
                    totalPages = (int)Math.Ceiling((double)total / pageSize)
                },
                data = citas
            });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al paginar citas.");

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Error interno del servidor."
                });
            }
        }
        [HttpPost]
        public async Task<IActionResult> PostCita(Cita cita)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                bool pacienteExiste = await _context.Pacientes
                    .AnyAsync(p => p.IdPaciente == cita.IdPaciente);

                if (!pacienteExiste)
                {
                    return BadRequest(new ApiError
                    {
                        StatusCode = 400,
                        Timestamp = DateTime.Now,
                        Message = "El paciente no existe."
                    });
                }

                bool odontologoExiste = await _context.Odontologos
                    .AnyAsync(o => o.IdOdontologo == cita.IdOdontologo);

                if (!odontologoExiste)
                {
                    return BadRequest(new ApiError
                    {
                        StatusCode = 400,
                        Timestamp = DateTime.Now,
                        Message = "El odontólogo no existe."
                    });
                }

                _context.Citas.Add(cita);

                await _context.SaveChangesAsync();

                _cache.Remove("CITAS_CACHE");

                return CreatedAtAction(nameof(GetCita),
                    new { id = cita.IdCita },
                    new ApiResponse<Cita>
                    {
                        Success = true,
                        Message = "Cita registrada correctamente.",
                        Data = cita
                    });
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error al registrar cita.");

                    return StatusCode(500, new ApiError
                    {
                        StatusCode = 500,
                        Timestamp = DateTime.Now,
                        Message = "Error interno del servidor."
                    });
                }
            }
        //=================================================
        // PUT: api/citas/5
        //=================================================
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCita(int id, Cita cita)
        {
            try
            {
                if (id != cita.IdCita)
                {
                    return BadRequest(new ApiError
                    {
                        StatusCode = 400,
                        Timestamp = DateTime.Now,
                        Message = "El ID enviado no coincide."
                    });
                }

                var citaExistente = await _context.Citas
                    .FirstOrDefaultAsync(c => c.IdCita == id);

                if (citaExistente == null)
                {
                    return NotFound(new ApiError
                    {
                        StatusCode = 404,
                        Timestamp = DateTime.Now,
                        Message = "Cita no encontrada."
                    });
                }

                // Validar que el paciente exista
                bool pacienteExiste = await _context.Pacientes
                    .AnyAsync(p => p.IdPaciente == cita.IdPaciente);

                if (!pacienteExiste)
                {
                    return BadRequest(new ApiError
                    {
                        StatusCode = 400,
                        Timestamp = DateTime.Now,
                        Message = "El paciente no existe."
                    });
                }

                // Validar que el odontólogo exista
                bool odontologoExiste = await _context.Odontologos
                    .AnyAsync(o => o.IdOdontologo == cita.IdOdontologo);

                if (!odontologoExiste)
                {
                    return BadRequest(new ApiError
                    {
                        StatusCode = 400,
                        Timestamp = DateTime.Now,
                        Message = "El odontólogo no existe."
                    });
                }

                // Validar estado
                if (cita.Estado != "Programada" &&
                    cita.Estado != "Atendida" &&
                    cita.Estado != "Cancelada")
                {
                    return BadRequest(new ApiError
                    {
                        StatusCode = 400,
                        Timestamp = DateTime.Now,
                        Message = "El estado debe ser Programada, Atendida o Cancelada."
                    });
                }

                // Actualizar propiedades
                citaExistente.Fecha = cita.Fecha;
                citaExistente.Estado = cita.Estado;
                citaExistente.IdPaciente = cita.IdPaciente;
                citaExistente.IdOdontologo = cita.IdOdontologo;

                await _context.SaveChangesAsync();

                // Invalidar caché
                _cache.Remove("CITAS_CACHE");

                _logger.LogInformation(
                    "Cita con ID {IdCita} actualizada correctamente.",
                    id);

                return Ok(new ApiResponse<Cita>
                {
                    Success = true,
                    Message = "Cita actualizada correctamente.",
                    Data = citaExistente
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(
                    ex,
                    "Error al actualizar cita con ID {IdCita}.",
                    id);

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Error interno del servidor."
                });
            }
        }
        //=================================================
        // DELETE: api/citas/5
        //=================================================
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCita(int id)
        {
            try
            {
                var cita = await _context.Citas
                    .FirstOrDefaultAsync(c => c.IdCita == id);

                if (cita == null)
                {
                    return NotFound(new ApiError
                    {
                        StatusCode = 404,
                        Timestamp = DateTime.Now,
                        Message = "Cita no encontrada."
                    });
                }

                _context.Citas.Remove(cita);

                await _context.SaveChangesAsync();

                // Invalidar caché
                _cache.Remove("CITAS_CACHE");

                _logger.LogInformation(
                    "Cita con ID {IdCita} eliminada correctamente.",
                    id);

                return Ok(new ApiResponse<string>
                {
                    Success = true,
                    Message = "Cita eliminada correctamente.",
                    Data = null
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(
                    ex,
                    "Error al eliminar cita con ID {IdCita}.",
                    id);

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Error interno del servidor."
                });
            }
        }
    }

}
