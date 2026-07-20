using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DentisAppAPI.Migrations
{
    /// <inheritdoc />
    public partial class NuevaMigracionCitas : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CITA_TRATAMIENTO_CITA_CitaId",
                table: "CITA_TRATAMIENTO");

            migrationBuilder.DropForeignKey(
                name: "FK_CITA_TRATAMIENTO_TRATAMIENTO_TratamientoId",
                table: "CITA_TRATAMIENTO");

            migrationBuilder.DropPrimaryKey(
                name: "PK_TRATAMIENTO",
                table: "TRATAMIENTO");

            migrationBuilder.DropPrimaryKey(
                name: "PK_PAGO",
                table: "PAGO");

            migrationBuilder.DropPrimaryKey(
                name: "PK_PACIENTE",
                table: "PACIENTE");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ODONTOLOGO",
                table: "ODONTOLOGO");

            migrationBuilder.DropPrimaryKey(
                name: "PK_CITA",
                table: "CITA");

            migrationBuilder.RenameTable(
                name: "TRATAMIENTO",
                newName: "TRATAMIENTOS");

            migrationBuilder.RenameTable(
                name: "PAGO",
                newName: "PAGOS");

            migrationBuilder.RenameTable(
                name: "PACIENTE",
                newName: "PACIENTES");

            migrationBuilder.RenameTable(
                name: "ODONTOLOGO",
                newName: "ODONTOLOGOS");

            migrationBuilder.RenameTable(
                name: "CITA",
                newName: "CITAS");

            migrationBuilder.AddPrimaryKey(
                name: "PK_TRATAMIENTOS",
                table: "TRATAMIENTOS",
                column: "IdTratamiento");

            migrationBuilder.AddPrimaryKey(
                name: "PK_PAGOS",
                table: "PAGOS",
                column: "IdPago");

            migrationBuilder.AddPrimaryKey(
                name: "PK_PACIENTES",
                table: "PACIENTES",
                column: "IdPaciente");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ODONTOLOGOS",
                table: "ODONTOLOGOS",
                column: "IdOdontologo");

            migrationBuilder.AddPrimaryKey(
                name: "PK_DENTIS_CITA",
                table: "CITAS",
                column: "IdCita");

            migrationBuilder.AddForeignKey(
                name: "FK_CITA_TRATAMIENTO_CITAS_CitaId",
                table: "CITA_TRATAMIENTO",
                column: "CitaId",
                principalTable: "CITAS",
                principalColumn: "IdCita",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CITA_TRATAMIENTO_TRATAMIENTOS_TratamientoId",
                table: "CITA_TRATAMIENTO",
                column: "TratamientoId",
                principalTable: "TRATAMIENTOS",
                principalColumn: "IdTratamiento",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CITA_TRATAMIENTO_CITAS_CitaId",
                table: "CITA_TRATAMIENTO");

            migrationBuilder.DropForeignKey(
                name: "FK_CITA_TRATAMIENTO_TRATAMIENTOS_TratamientoId",
                table: "CITA_TRATAMIENTO");

            migrationBuilder.DropPrimaryKey(
                name: "PK_TRATAMIENTOS",
                table: "TRATAMIENTOS");

            migrationBuilder.DropPrimaryKey(
                name: "PK_PAGOS",
                table: "PAGOS");

            migrationBuilder.DropPrimaryKey(
                name: "PK_PACIENTES",
                table: "PACIENTES");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ODONTOLOGOS",
                table: "ODONTOLOGOS");

            migrationBuilder.DropPrimaryKey(
                name: "PK_DENTIS_CITA",
                table: "CITAS");

            migrationBuilder.RenameTable(
                name: "TRATAMIENTOS",
                newName: "TRATAMIENTO");

            migrationBuilder.RenameTable(
                name: "PAGOS",
                newName: "PAGO");

            migrationBuilder.RenameTable(
                name: "PACIENTES",
                newName: "PACIENTE");

            migrationBuilder.RenameTable(
                name: "ODONTOLOGOS",
                newName: "ODONTOLOGO");

            migrationBuilder.RenameTable(
                name: "CITAS",
                newName: "CITA");

            migrationBuilder.AddPrimaryKey(
                name: "PK_TRATAMIENTO",
                table: "TRATAMIENTO",
                column: "IdTratamiento");

            migrationBuilder.AddPrimaryKey(
                name: "PK_PAGO",
                table: "PAGO",
                column: "IdPago");

            migrationBuilder.AddPrimaryKey(
                name: "PK_PACIENTE",
                table: "PACIENTE",
                column: "IdPaciente");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ODONTOLOGO",
                table: "ODONTOLOGO",
                column: "IdOdontologo");

            migrationBuilder.AddPrimaryKey(
                name: "PK_CITA",
                table: "CITA",
                column: "IdCita");

            migrationBuilder.AddForeignKey(
                name: "FK_CITA_TRATAMIENTO_CITA_CitaId",
                table: "CITA_TRATAMIENTO",
                column: "CitaId",
                principalTable: "CITA",
                principalColumn: "IdCita",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CITA_TRATAMIENTO_TRATAMIENTO_TratamientoId",
                table: "CITA_TRATAMIENTO",
                column: "TratamientoId",
                principalTable: "TRATAMIENTO",
                principalColumn: "IdTratamiento",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
