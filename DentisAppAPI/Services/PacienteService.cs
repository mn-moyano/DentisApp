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

            string query = "SELECT IDPACIENTE, NOMBRE, APELLIDO, CEDULA, FECHANACIMIENTO, TELEFONO, CORREO, DIRECCION FROM PACIENTES";

            using var command = new OracleCommand(query, connection);
            using var reader = command.ExecuteReader();

            while (reader.Read())
            {
                pacientes.Add(new Paciente
                {
                    IdPaciente = reader.GetInt32(0),
                    Nombre = reader.IsDBNull(1) ? null : reader.GetString(1),
                    Apellido = reader.IsDBNull(2) ? null : reader.GetString(2),
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

            string query = @"INSERT INTO PACIENTES (NOMBRE, APELLIDO, CEDULA, FECHANACIMIENTO, TELEFONO, CORREO, DIRECCION)
                             VALUES (:nombre, :apellido, :cedula, :fechaNacimiento, :telefono, :correo, :direccion)";

            using var command = new OracleCommand(query, connection);
            command.Parameters.Add(new OracleParameter("nombre", paciente.Nombre));
            command.Parameters.Add(new OracleParameter("apellido", paciente.Apellido));
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

            string query = @"UPDATE PACIENTES SET NOMBRE=:nombre, APELLIDO=:apellido, CEDULA=:cedula, 
                             FECHANACIMIENTO=:fechaNacimiento, TELEFONO=:telefono, CORREO=:correo, DIRECCION=:direccion
                             WHERE IDPACIENTE=:idPaciente";

            using var command = new OracleCommand(query, connection);
            command.Parameters.Add(new OracleParameter("nombre", paciente.Nombre));
            command.Parameters.Add(new OracleParameter("apellido", paciente.Apellido));
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

            string query = "DELETE FROM PACIENTES WHERE IDPACIENTE=:idPaciente";

            using var command = new OracleCommand(query, connection);
            command.Parameters.Add(new OracleParameter("idPaciente", idPaciente));

            command.ExecuteNonQuery();
        }
    }
}
