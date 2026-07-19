using DentisAppAPI.Models;
using DentisAppAPI.Repositories;

namespace DentisAppAPI.Services;

/// Servicio de negocio para pacientes.
/// Encapsula la lógica y deja el repositorio como punto de intercambio.
public class PacienteService
{
    private readonly PacienteRepository _repository = new();

    public IEnumerable<Paciente> ObtenerTodos() => _repository.ObtenerTodos();

    public Paciente? ObtenerPorId(int id) => _repository.ObtenerPorId(id);

    public Paciente Agregar(Paciente paciente)
    {
        _repository.Agregar(paciente);
        return paciente;
    }

    public Paciente? Actualizar(Paciente paciente)
    {
        _repository.Actualizar(paciente);
        return _repository.ObtenerPorId(paciente.IdPaciente ?? 0);
    }

    public bool Eliminar(int id)
    {
        _repository.Eliminar(id);
        return _repository.ObtenerPorId(id) is null;
    }
}
