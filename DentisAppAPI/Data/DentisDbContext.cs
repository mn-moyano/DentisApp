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

        public DbSet<Paciente> Pacientes { get; set; }
        public DbSet<Odontologo> Odontologos { get; set; }
        public DbSet<Cita> Citas { get; set; }
        public DbSet<Tratamiento> Tratamientos { get; set; }
        public DbSet<Pago> Pagos { get; set; }
        public DbSet<CitaTratamiento> CitaTratamientos { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<CitaTratamiento>()
                .HasKey(ct => new { ct.CitaId, ct.TratamientoId });
        }
    }
}