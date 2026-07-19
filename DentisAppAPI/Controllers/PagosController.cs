using Microsoft.AspNetCore.Mvc;
using DentisAppAPI.Models;

namespace DentisAppAPI.Controllers;

/// Controlador para gestionar los pagos del sistema.
[ApiController]
[Route("api/[controller]")]
public class PagosController : ControllerBase
{
    // Lista en memoria para simular almacenamiento temporal.
    private static readonly List<Pago> Pagos = new()
    {
        new Pago { IdPago = 1, FechaPago = new DateTime(2026, 7, 20), Monto = 35, MetodoPago = "Efectivo", IdCita = 1 },
        new Pago { IdPago = 2, FechaPago = new DateTime(2026, 7, 21), Monto = 60, MetodoPago = "Tarjeta", IdCita = 2 },
        new Pago { IdPago = 3, FechaPago = new DateTime(2026, 7, 22), Monto = 80, MetodoPago = "Transferencia", IdCita = 3 }
    };

    /// Obtiene la lista de todos los pagos.
    [HttpGet]
    public ActionResult<IEnumerable<Pago>> Get() => Ok(Pagos);

    /// Obtiene un pago por su identificador.
    [HttpGet("{id}")]
    public ActionResult<Pago> Get(int id)
    {
        var pago = Pagos.FirstOrDefault(p => p.IdPago == id);
        return pago is null ? NotFound() : Ok(pago);
    }

    /// Crea un nuevo pago.
    [HttpPost]
    public ActionResult<Pago> Post(Pago pago)
    {
        pago.IdPago = Pagos.Count + 1;
        Pagos.Add(pago);
        return CreatedAtAction(nameof(Get), new { id = pago.IdPago }, pago);
    }

    /// Actualiza un pago existente.
    [HttpPut("{id}")]
    public ActionResult<Pago> Put(int id, Pago pago)
    {
        var existing = Pagos.FirstOrDefault(p => p.IdPago == id);
        if (existing is null) return NotFound();

        existing.FechaPago = pago.FechaPago;
        existing.Monto = pago.Monto;
        existing.MetodoPago = pago.MetodoPago;
        existing.IdCita = pago.IdCita;

        return Ok(existing);
    }

    /// Elimina un pago por su identificador.
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        var pago = Pagos.FirstOrDefault(p => p.IdPago == id);
        if (pago is null) return NotFound();

        Pagos.Remove(pago);
        return NoContent();
    }
}
