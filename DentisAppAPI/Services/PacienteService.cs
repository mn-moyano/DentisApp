using DentisAppAPI.Models;
using Oracle.ManagedDataAccess.Client;

namespace DentisAppAPI.Services
{
    public class PacienteService
    {
        private readonly string _connectionString;

        public PacienteService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public List<Paciente> ObtenerPacientes()
        {
            var pacientes = new List<Paciente>();

            using var connection = new OracleConnection(_connectionString);
            connection.Open();

            string query = "SELECT ID_PACIENTE, NOMBRES, APELLIDOS, CEDULA, FECHA_NACIMIENTO, TELEFONO, CORREO, DIRECCION FROM PACIENTES";

            using var command = new OracleCommand(query, connection);
            using var reader = command.ExecuteReader();

            while (reader.Read())
            {
                pacientes.Add(new Paciente
                {
                    IdPaciente = reader.GetInt32(0),
                    Nombres = reader.IsDBNull(1) ? string.Empty : reader.GetString(1),
                    Apellidos = reader.IsDBNull(2) ? string.Empty : reader.GetString(2),
                    Cedula = reader.IsDBNull(3) ? null : reader.GetString(3),
                    FechaNacimiento = reader.IsDBNull(4) ? null : reader.GetDateTime(4),
                    Telefono = reader.IsDBNull(5) ? null : reader.GetString(5),
                    Correo = reader.IsDBNull(6) ? null : reader.GetString(6),
                    Direccion = reader.IsDBNull(7) ? null : reader.GetString(7)
                });
            }

            return pacientes;
        }

        public void CrearPaciente(Paciente paciente)
        {
            using var connection = new OracleConnection(_connectionString);
            connection.Open();

            string query = @"INSERT INTO PACIENTES (NOMBRES, APELLIDOS, CEDULA, FECHA_NACIMIENTO, TELEFONO, CORREO, DIRECCION)
                             VALUES (:nombres, :apellidos, :cedula, :fechaNacimiento, :telefono, :correo, :direccion)";

            using var command = new OracleCommand(query, connection);
            command.Parameters.Add(new OracleParameter("nombres", paciente.Nombres));
            command.Parameters.Add(new OracleParameter("apellidos", paciente.Apellidos));
            command.Parameters.Add(new OracleParameter("cedula", paciente.Cedula));
            command.Parameters.Add(new OracleParameter("fechaNacimiento", paciente.FechaNacimiento));
            command.Parameters.Add(new OracleParameter("telefono", paciente.Telefono));
            command.Parameters.Add(new OracleParameter("correo", paciente.Correo));
            command.Parameters.Add(new OracleParameter("direccion", paciente.Direccion));

            command.ExecuteNonQuery();
        }

        public void ActualizarPaciente(Paciente paciente)
        {
            using var connection = new OracleConnection(_connectionString);
            connection.Open();

            string query = @"UPDATE PACIENTES SET NOMBRES=:nombres, APELLIDOS=:apellidos, CEDULA=:cedula, 
                             FECHA_NACIMIENTO=:fechaNacimiento, TELEFONO=:telefono, CORREO=:correo, DIRECCION=:direccion
                             WHERE ID_PACIENTE=:idPaciente";

            using var command = new OracleCommand(query, connection);
            command.Parameters.Add(new OracleParameter("nombres", paciente.Nombres));
            command.Parameters.Add(new OracleParameter("apellidos", paciente.Apellidos));
            command.Parameters.Add(new OracleParameter("cedula", paciente.Cedula));
            command.Parameters.Add(new OracleParameter("fechaNacimiento", paciente.FechaNacimiento));
            command.Parameters.Add(new OracleParameter("telefono", paciente.Telefono));
            command.Parameters.Add(new OracleParameter("correo", paciente.Correo));
            command.Parameters.Add(new OracleParameter("direccion", paciente.Direccion));
            command.Parameters.Add(new OracleParameter("idPaciente", paciente.IdPaciente));

            command.ExecuteNonQuery();
        }

        public void EliminarPaciente(int idPaciente)
        {
            using var connection = new OracleConnection(_connectionString);
            connection.Open();

            string query = "DELETE FROM PACIENTES WHERE ID_PACIENTE=:idPaciente";

            using var command = new OracleCommand(query, connection);
            command.Parameters.Add(new OracleParameter("idPaciente", idPaciente));

            command.ExecuteNonQuery();
        }
    }
}
