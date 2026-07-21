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
    public class OdontologosController : ControllerBase
    {
        private readonly DentisAppContext _context;
        private readonly IMemoryCache _cache;
        private readonly ILogger<OdontologosController> _logger;

        public OdontologosController(
            DentisAppContext context,
            IMemoryCache cache,
            ILogger<OdontologosController> logger)
        {
            _context = context;
            _cache = cache;
            _logger = logger;
        }

        //=================================================
        // GET: api/odontologos
        //=================================================
        [HttpGet]
        public async Task<IActionResult> GetOdontologos()
        {
            try
            {
                const string cacheKey = "ODONTOLOGOS_CACHE";

                if (!_cache.TryGetValue(cacheKey, out List<Odontologo>? odontologos))
                {
                    odontologos = await _context.Odontologos
                        .AsNoTracking()
                        .OrderBy(o => o.Nombres)
                        .ToListAsync();

                    _cache.Set(
                        cacheKey,
                        odontologos,
                        new MemoryCacheEntryOptions()
                            .SetAbsoluteExpiration(TimeSpan.FromMinutes(5)));

                    _logger.LogInformation("Odontólogos obtenidos desde Oracle.");
                }
                else
                {
                    _logger.LogInformation("Odontólogos obtenidos desde caché.");
                }

                return Ok(new ApiResponse<List<Odontologo>>
                {
                    Success = true,
                    Message = "Listado obtenido correctamente.",
                    Data = odontologos
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al listar odontólogos.");

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Error interno del servidor."
                });
            }
        }

        //=================================================
        // GET: api/odontologos/5
        //=================================================
        [HttpGet("{id}")]
        public async Task<IActionResult> GetOdontologo(int id)
        {
            try
            {
                var odontologo = await _context.Odontologos
                    .AsNoTracking()
                    .FirstOrDefaultAsync(o => o.IdOdontologo == id);

                if (odontologo == null)
                {
                    return NotFound(new ApiError
                    {
                        StatusCode = 404,
                        Timestamp = DateTime.Now,
                        Message = "Odontólogo no encontrado."
                    });
                }

                return Ok(new ApiResponse<Odontologo>
                {
                    Success = true,
                    Message = "Odontólogo obtenido correctamente.",
                    Data = odontologo
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al consultar odontólogo.");

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Error interno del servidor."
                });
            }
        }

        //=================================================
        // GET PAGINADO
        //=================================================
        [HttpGet("paginado")]
        public async Task<IActionResult> GetOdontologosPaginado(
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

                int total = await _context.Odontologos.CountAsync();

                var odontologos = await _context.Odontologos
                    .AsNoTracking()
                    .OrderBy(o => o.Nombres)
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
                    data = odontologos
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error en paginación.");

                return StatusCode(500, new ApiError
                {
                    StatusCode = 500,
                    Timestamp = DateTime.Now,
                    Message = "Error interno del servidor."
                });
            }
        }
            //=================================================
            // POST: api/odontologos
            //=================================================
            [HttpPost]
            public async Task<IActionResult> PostOdontologo(Odontologo odontologo)
            {
                try
                {
                    if (!ModelState.IsValid)
                        return BadRequest(ModelState);

                    if (odontologo == null)
                    {
                        return BadRequest(new ApiError
                        {
                            StatusCode = 400,
                            Timestamp = DateTime.Now,
                            Message = "Los datos enviados son inválidos."
                        });
                    }

                    // Verificar correo duplicado
                        bool correoExiste = await _context.Odontologos
                            .AnyAsync(o => o.Correo == odontologo.Correo);

                        if (correoExiste)
                        {
                            return Conflict(new ApiError
                            {
                                StatusCode = 409,
                                Timestamp = DateTime.Now,
                                Message = "El correo ya se encuentra registrado."
                            });
                        }

                        // Regla de negocio
                        if (odontologo.Estado != "Activo" &&
                            odontologo.Estado != "Inactivo")
                        {
                            return BadRequest(new ApiError
                            {
                                StatusCode = 400,
                                Timestamp = DateTime.Now,
                                Message = "El estado debe ser Activo o Inactivo."
                            });
                        }

                        _context.Odontologos.Add(odontologo);

                        await _context.SaveChangesAsync();

                        // Invalidar caché
                        _cache.Remove("ODONTOLOGOS_CACHE");

                        _logger.LogInformation(
                            "Odontólogo {Nombre} registrado correctamente.",
                            odontologo.Nombres);

                        return CreatedAtAction(
                            nameof(GetOdontologo),
                            new { id = odontologo.IdOdontologo },
                            new ApiResponse<Odontologo>
                            {
                                Success = true,
                                Message = "Odontólogo registrado correctamente.",
                                Data = odontologo
                            });
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex,
                            "Error al registrar odontólogo.");

                        return StatusCode(500,
                            new ApiError
                            {
                                StatusCode = 500,
                                Timestamp = DateTime.Now,
                                Message = "Ocurrió un error interno del servidor."
                            });
                    }
                }
                //=================================================
                // PUT: api/odontologos/5
                //=================================================
                [HttpPut("{id}")]
                public async Task<IActionResult> PutOdontologo(int id, Odontologo odontologo)
                {
                    try
                    {
                        if (id != odontologo.IdOdontologo)
                        {
                            return BadRequest(new ApiError
                            {
                                StatusCode = 400,
                                Timestamp = DateTime.Now,
                                Message = "El ID enviado no coincide."
                            });
                        }

                        var odontologoExistente = await _context.Odontologos
                            .FirstOrDefaultAsync(o => o.IdOdontologo == id);

                        if (odontologoExistente == null)
                        {
                            return NotFound(new ApiError
                            {
                                StatusCode = 404,
                                Timestamp = DateTime.Now,
                                Message = "Odontólogo no encontrado."
                            });
                        }

                        bool correoDuplicado = await _context.Odontologos
                            .AnyAsync(o =>
                                o.Correo == odontologo.Correo &&
                                o.IdOdontologo != id);

                        if (correoDuplicado)
                        {
                            return Conflict(new ApiError
                            {
                                StatusCode = 409,
                                Timestamp = DateTime.Now,
                                Message = "El correo pertenece a otro odontólogo."
                            });
                        }

                        if (odontologo.Estado != "Activo" &&
                            odontologo.Estado != "Inactivo")
                        {
                            return BadRequest(new ApiError
                            {
                                StatusCode = 400,
                                Timestamp = DateTime.Now,
                                Message = "El estado debe ser Activo o Inactivo."
                            });
                        }

                        // Actualizar campos
                        odontologoExistente.Nombres = odontologo.Nombres;
                        odontologoExistente.Apellidos = odontologo.Apellidos;
                        odontologoExistente.Especialidad = odontologo.Especialidad;
                        odontologoExistente.Telefono = odontologo.Telefono;
                        odontologoExistente.Correo = odontologo.Correo;
                        odontologoExistente.Estado = odontologo.Estado;

                        await _context.SaveChangesAsync();

                        _cache.Remove("ODONTOLOGOS_CACHE");

                        _logger.LogInformation(
                            "Odontólogo con ID {IdOdontologo} actualizado correctamente.",
                            id);

                        return Ok(new ApiResponse<Odontologo>
                        {
                            Success = true,
                            Message = "Odontólogo actualizado correctamente.",
                            Data = odontologoExistente
                        });
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex,
                            "Error al actualizar odontólogo con ID {IdOdontologo}.",
                            id);

                        return StatusCode(500,
                            new ApiError
                            {
                                StatusCode = 500,
                                Timestamp = DateTime.Now,
                                Message = "Ocurrió un error interno del servidor."
                            });
                    }
                }
                //=================================================
                // DELETE: api/odontologos/5
                //=================================================
                [HttpDelete("{id}")]
                public async Task<IActionResult> DeleteOdontologo(int id)
                {
                    try
                    {
                        var odontologo = await _context.Odontologos
                            .FirstOrDefaultAsync(o => o.IdOdontologo == id);

                        if (odontologo == null)
                        {
                            return NotFound(new ApiError
                            {
                                StatusCode = 404,
                                Timestamp = DateTime.Now,
                                Message = "Odontólogo no encontrado."
                            });
                        }

                        _context.Odontologos.Remove(odontologo);

                        await _context.SaveChangesAsync();

                        // Invalidar caché
                        _cache.Remove("ODONTOLOGOS_CACHE");

                        _logger.LogInformation(
                            "Odontólogo con ID {IdOdontologo} eliminado correctamente.",
                            id);

                        return Ok(new ApiResponse<object>
                        {
                            Success = true,
                            Message = "Odontólogo eliminado correctamente.",
                            Data = null
                        });
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(
                            ex,
                            "Error al eliminar odontólogo con ID {IdOdontologo}.",
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