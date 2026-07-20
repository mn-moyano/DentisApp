using DentisAppAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace DentisAppAPI.Data
{
    public class DentisAppContext : DbContext
    {
        public DentisAppContext(DbContextOptions<DentisAppContext> options)
            : base(options)
        {
        }

        // Tablas
        public DbSet<Paciente> Pacientes { get; set; }
        public DbSet<Odontologo> Odontologos { get; set; }
        public DbSet<Cita> Citas { get; set; }
        public DbSet<Tratamiento> Tratamientos { get; set; }
        public DbSet<Pago> Pagos { get; set; }
        public DbSet<CitaTratamiento> CitaTratamientos { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Llave primaria compuesta
            modelBuilder.Entity<CitaTratamiento>()
                .HasKey(ct => new { ct.CitaId, ct.TratamientoId });

            // Nombres de tablas en Oracle
            modelBuilder.Entity<Paciente>().ToTable("PACIENTES");
            modelBuilder.Entity<Odontologo>().ToTable("ODONTOLOGOS");
            modelBuilder.Entity<Cita>().ToTable("CITAS");
            modelBuilder.Entity<Tratamiento>().ToTable("TRATAMIENTOS");
            modelBuilder.Entity<Pago>().ToTable("PAGOS");
            modelBuilder.Entity<CitaTratamiento>().ToTable("CITA_TRATAMIENTO");
            // Configuración para el Monto del Pago
            modelBuilder.Entity<Pago>()
            .Property(p => p.Monto)
            .HasPrecision(18, 2); // 18 dígitos en total, 2 decimales para los centavos

            // Configuración para el Costo del Tratamiento
            modelBuilder.Entity<Tratamiento>()
            .Property(t => t.Costo)
            .HasPrecision(18, 2);
            // Cambia el nombre del constraint a algo único, por ejemplo, PK_DENTIS_CITA
            modelBuilder.Entity<Cita>()
            .HasKey(c => c.IdCita)
            .HasName("PK_DENTIS_CITA");
        }
    }
}