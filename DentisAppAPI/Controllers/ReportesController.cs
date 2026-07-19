using Microsoft.AspNetCore.Mvc;
using DentisAppAPI.Models;

namespace DentisAppAPI.Controllers;

/// Controlador para ofrecer reportes generales del sistema.
[ApiController]
[Route("api/[controller]")]
public class ReportesController : ControllerBase
{
    /// Devuelve un resumen general de información disponible en el sistema.
    [HttpGet]
    public ActionResult<object> Get()
    {
        return Ok(new
        {
            totalPacientes = 3,
            totalOdontologos = 3,
            totalCitas = 3,
            totalPagos = 3,
            totalTratamientos = 3
        });
    }
}
