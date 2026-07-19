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
            modelBuilder.Entity<Paciente>().ToTable("PACIENTE");
            modelBuilder.Entity<Odontologo>().ToTable("ODONTOLOGO");
            modelBuilder.Entity<Cita>().ToTable("CITA");
            modelBuilder.Entity<Tratamiento>().ToTable("TRATAMIENTO");
            modelBuilder.Entity<Pago>().ToTable("PAGO");
            modelBuilder.Entity<CitaTratamiento>().ToTable("CITA_TRATAMIENTO");
        }
    }
}