using DentisAppAPI.Models;

namespace DentisAppAPI.Repositories;

/// Repositorio base para pacientes.
/// Se deja preparado para adaptarse a Entity Framework o a una fuente externa.
public class PacienteRepository
{
    private readonly List<Paciente> _pacientes = new();

    public IEnumerable<Paciente> ObtenerTodos() => _pacientes;

    public Paciente? ObtenerPorId(int id) => _pacientes.FirstOrDefault(p => p.IdPaciente == id);

    public void Agregar(Paciente paciente)
    {
        paciente.IdPaciente = (_pacientes.Count > 0 ? _pacientes.Max(p => p.IdPaciente) : 0) + 1;
        _pacientes.Add(paciente);
    }

    public void Actualizar(Paciente pacienteActualizado)
    {
        var existente = _pacientes.FirstOrDefault(p => p.IdPaciente == pacienteActualizado.IdPaciente);
        if (existente is null) return;

        existente.Nombres = pacienteActualizado.Nombres;
        existente.Apellidos = pacienteActualizado.Apellidos;
        existente.Cedula = pacienteActualizado.Cedula;
        existente.FechaNacimiento = pacienteActualizado.FechaNacimiento;
        existente.Telefono = pacienteActualizado.Telefono;
        existente.Correo = pacienteActualizado.Correo;
        existente.Direccion = pacienteActualizado.Direccion;
    }

    public void Eliminar(int id)
    {
        var paciente = _pacientes.FirstOrDefault(p => p.IdPaciente == id);
        if (paciente is not null)
        {
            _pacientes.Remove(paciente);
        }
    }
}
