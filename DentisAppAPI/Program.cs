using DentisAppAPI.Services;
using DentisAppAPI.Data; // IMPORTANTE: Para que reconozca DentisDbContext
using Microsoft.EntityFrameworkCore; // IMPORTANTE: Para usar Entity Framework

var builder = WebApplication.CreateBuilder(args);

// --- 1. CONFIGURACIÓN DE LA BASE DE DATOS ORACLE ---
// Esta línea conecta tu API con Oracle usando la cadena de conexión del appsettings.json
builder.Services.AddDbContext<DentisDbContext>(options =>
    options.UseOracle(builder.Configuration.GetConnectionString("DefaultConnection")));


// --- 2. REGISTRO DE SERVICIOS ---
builder.Services.AddControllers();
builder.Services.AddScoped<PacienteService>();
// Si tienes repositorios, debes registrarlos aquí también. Ejemplo:
// builder.Services.AddScoped<IPacienteRepository, PacienteRepository>();

// --- 3. SWAGGER/OPENAPI ---
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// --- 4. CONFIGURAR CORS ---
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy => policy.AllowAnyOrigin()
                        .AllowAnyMethod()
                        .AllowAnyHeader());
});

var app = builder.Build();

// Habilitar Swagger en desarrollo
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");
app.MapControllers();

app.Run();