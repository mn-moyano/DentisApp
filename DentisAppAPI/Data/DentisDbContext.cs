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

            //==============================
            // Clave compuesta
            //==============================
            modelBuilder.Entity<CitaTratamiento>()
                .HasKey(ct => new
                {
                    ct.CitaId,
                    ct.TratamientoId
                });

            //==============================
            // CITA -> PACIENTE
            //==============================
            modelBuilder.Entity<Cita>()
                .HasOne(c => c.Paciente)
                .WithMany()
                .HasForeignKey(c => c.IdPaciente)
                .OnDelete(DeleteBehavior.Restrict);

            //==============================
            // CITA -> ODONTOLOGO
            //==============================
            modelBuilder.Entity<Cita>()
                .HasOne(c => c.Odontologo)
                .WithMany()
                .HasForeignKey(c => c.IdOdontologo)
                .OnDelete(DeleteBehavior.Restrict);

            //==============================
            // PAGO -> CITA
            //==============================
            modelBuilder.Entity<Pago>()
                .HasOne(p => p.Cita)
                .WithMany(c => c.Pagos)
                .HasForeignKey(p => p.IdCita)
                .OnDelete(DeleteBehavior.Cascade);

            //==============================
            // CITA_TRATAMIENTO -> CITA
            //==============================
            modelBuilder.Entity<CitaTratamiento>()
                .HasOne(ct => ct.Cita)
                .WithMany(c => c.CitaTratamientos)
                .HasForeignKey(ct => ct.CitaId)
                .OnDelete(DeleteBehavior.Cascade);

            //==============================
            // CITA_TRATAMIENTO -> TRATAMIENTO
            //==============================
            modelBuilder.Entity<CitaTratamiento>()
                .HasOne(ct => ct.Tratamiento)
                .WithMany(t => t.CitaTratamientos)
                .HasForeignKey(ct => ct.TratamientoId)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}