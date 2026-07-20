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

        public PacientesController(DentisAppContext context, IMemoryCache cache)
        {
            _context = context;
            _cache = cache;
        }

        //===========================================
        // GET: api/pacientes
        //===========================================
        [HttpGet]
        public async Task<IActionResult> GetPacientes()
        {
            try
            {
                const string cacheKey = "PACIENTES_CACHE";

                if (!_cache.TryGetValue(cacheKey, out List<Paciente>? pacientes))
                {
                    pacientes = await _context.Pacientes
                        .OrderBy(p => p.Nombres)
                        .ToListAsync();

                    var opciones = new MemoryCacheEntryOptions()
                        .SetAbsoluteExpiration(TimeSpan.FromMinutes(5));

                    _cache.Set(cacheKey, pacientes, opciones);
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
                return StatusCode(500, new ApiError
                {
                    Message = $"Error interno: {ex.Message}"
                });
            }
        }
        //===========================================
        // GET: api/pacientes/5
        //===========================================
        [HttpGet("{id}")]
        public async Task<IActionResult> GetPaciente(int id)
        {
            try
            {
                var paciente = await _context.Pacientes.FindAsync(id);

                if (paciente == null)
                {
                    return NotFound(new ApiError
                    {
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
                return StatusCode(500, new ApiError
                {
                    Message = $"Error interno: {ex.Message}"
                });
            }
        }
        //===========================================
        // GET: api/pacientes/paginado?page=1&pageSize=10
        //===========================================
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

                int totalRegistros = await _context.Pacientes.CountAsync();

                var pacientes = await _context.Pacientes
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
                return StatusCode(500, new ApiError
                {
                    Message = $"Error interno: {ex.Message}"
                });
            }
        }
        //===========================================
        // POST: api/pacientes
        //===========================================
        [HttpPost]
        public async Task<IActionResult> PostPaciente(Paciente paciente)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                bool cedulaExiste = await _context.Pacientes
                    .AnyAsync(p => p.Cedula == paciente.Cedula);

                if (cedulaExiste)
                {
                    return Conflict(new ApiError
                    {
                        Message = "La cédula ya se encuentra registrada."
                    });
                }

                bool correoExiste = await _context.Pacientes
                    .AnyAsync(p => p.Correo == paciente.Correo);

                if (correoExiste)
                {
                    return Conflict(new ApiError
                    {
                        Message = "El correo ya se encuentra registrado."
                    });
                }

                _context.Pacientes.Add(paciente);
                await _context.SaveChangesAsync();
                _cache.Remove("PACIENTES_CACHE"); // Limpiar la caché después de agregar un nuevo paciente

                return CreatedAtAction(nameof(GetPaciente),
                    new { id = paciente.IdPaciente },
                    new ApiResponse<Paciente>
                    {
                        Success = true,
                        Message = "Paciente registrado correctamente.",
                        Data = paciente
                    }
                );
            }
            catch (Exception ex)
            {
                return StatusCode(500, new ApiError
                {
                    Message = $"Error interno: {ex.Message}"
                });
            }
        }

        //===========================================
        // PUT: api/pacientes/5
        //===========================================
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPaciente(int id, Paciente paciente)
        {
            try
            {
                if (id != paciente.IdPaciente)
                {
                    return BadRequest(new ApiError
                    {
                        Message = "El ID enviado no coincide."
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
                        Message = "El correo pertenece a otro paciente."
                    });
                }

                _context.Entry(paciente).State = EntityState.Modified;

                await _context.SaveChangesAsync();
                _cache.Remove("PACIENTES_CACHE");

                return Ok(new ApiResponse<Paciente>
                {
                    Success = true,
                    Message = "Paciente actualizado correctamente.",
                    Data = paciente
                });
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!await _context.Pacientes.AnyAsync(p => p.IdPaciente == id))
                {
                    return NotFound(new ApiError
                    {
                        Message = "Paciente no encontrado."
                    });
                }

                throw;
            }
            catch (Exception ex)
            {
                return StatusCode(500, new ApiError
                {
                    Message = $"Error interno: {ex.Message}"
                });
            }
        }

        //===========================================
        // DELETE: api/pacientes/5
        //===========================================
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePaciente(int id)
        {
            try
            {
                var paciente = await _context.Pacientes.FindAsync(id);

                if (paciente == null)
                {
                    return NotFound(new ApiError
                    {
                        Message = "Paciente no encontrado."
                    });
                }

                _context.Pacientes.Remove(paciente);

                await _context.SaveChangesAsync();
                _cache.Remove("PACIENTES_CACHE"); // Limpiar la caché después de eliminar un paciente

                return Ok(new ApiResponse<string>
                {
                    Success = true,
                    Message = "Paciente eliminado correctamente.",
                    Data = null
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new ApiError
                {
                    Message = $"Error interno: {ex.Message}"
                });
            }
        }
    }
}