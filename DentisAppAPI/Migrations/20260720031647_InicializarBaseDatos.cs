using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DentisAppAPI.Migrations
{
    /// <inheritdoc />
    public partial class InicializarBaseDatos : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CITA",
                columns: table => new
                {
                    IdCita = table.Column<int>(type: "NUMBER(10)", nullable: false)
                        .Annotation("Oracle:Identity", "START WITH 1 INCREMENT BY 1"),
                    Fecha = table.Column<DateTime>(type: "TIMESTAMP(7)", nullable: true),
                    Estado = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    IdPaciente = table.Column<int>(type: "NUMBER(10)", nullable: true),
                    IdOdontologo = table.Column<int>(type: "NUMBER(10)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CITA", x => x.IdCita);
                });

            migrationBuilder.CreateTable(
                name: "ODONTOLOGO",
                columns: table => new
                {
                    IdOdontologo = table.Column<int>(type: "NUMBER(10)", nullable: false)
                        .Annotation("Oracle:Identity", "START WITH 1 INCREMENT BY 1"),
                    Nombre = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    Especialidad = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    Telefono = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    Correo = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    Estado = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ODONTOLOGO", x => x.IdOdontologo);
                });

            migrationBuilder.CreateTable(
                name: "PACIENTE",
                columns: table => new
                {
                    IdPaciente = table.Column<int>(type: "NUMBER(10)", nullable: false)
                        .Annotation("Oracle:Identity", "START WITH 1 INCREMENT BY 1"),
                    Nombre = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    Apellido = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    Cedula = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    FechaNacimiento = table.Column<DateTime>(type: "TIMESTAMP(7)", nullable: true),
                    Telefono = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    Correo = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    Direccion = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PACIENTE", x => x.IdPaciente);
                });

            migrationBuilder.CreateTable(
                name: "PAGO",
                columns: table => new
                {
                    IdPago = table.Column<int>(type: "NUMBER(10)", nullable: false)
                        .Annotation("Oracle:Identity", "START WITH 1 INCREMENT BY 1"),
                    FechaPago = table.Column<DateTime>(type: "TIMESTAMP(7)", nullable: true),
                    Monto = table.Column<decimal>(type: "DECIMAL(18, 2)", nullable: true),
                    MetodoPago = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    IdCita = table.Column<int>(type: "NUMBER(10)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PAGO", x => x.IdPago);
                });

            migrationBuilder.CreateTable(
                name: "TRATAMIENTO",
                columns: table => new
                {
                    IdTratamiento = table.Column<int>(type: "NUMBER(10)", nullable: false)
                        .Annotation("Oracle:Identity", "START WITH 1 INCREMENT BY 1"),
                    Descripcion = table.Column<string>(type: "NVARCHAR2(2000)", nullable: true),
                    Costo = table.Column<decimal>(type: "DECIMAL(18, 2)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TRATAMIENTO", x => x.IdTratamiento);
                });

            migrationBuilder.CreateTable(
                name: "CITA_TRATAMIENTO",
                columns: table => new
                {
                    CitaId = table.Column<int>(type: "NUMBER(10)", nullable: false),
                    TratamientoId = table.Column<int>(type: "NUMBER(10)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CITA_TRATAMIENTO", x => new { x.CitaId, x.TratamientoId });
                    table.ForeignKey(
                        name: "FK_CITA_TRATAMIENTO_CITA_CitaId",
                        column: x => x.CitaId,
                        principalTable: "CITA",
                        principalColumn: "IdCita",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CITA_TRATAMIENTO_TRATAMIENTO_TratamientoId",
                        column: x => x.TratamientoId,
                        principalTable: "TRATAMIENTO",
                        principalColumn: "IdTratamiento",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_CITA_TRATAMIENTO_TratamientoId",
                table: "CITA_TRATAMIENTO",
                column: "TratamientoId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CITA_TRATAMIENTO");

            migrationBuilder.DropTable(
                name: "ODONTOLOGO");

            migrationBuilder.DropTable(
                name: "PACIENTE");

            migrationBuilder.DropTable(
                name: "PAGO");

            migrationBuilder.DropTable(
                name: "CITA");

            migrationBuilder.DropTable(
                name: "TRATAMIENTO");
        }
    }
}
