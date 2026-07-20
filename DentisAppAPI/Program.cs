using DentisAppAPI.Data;
using Microsoft.EntityFrameworkCore;

// Configura la API web y sus servicios principales.
var builder = WebApplication.CreateBuilder(args);

// Habilita los controladores y el contexto de base de datos.
builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<DentisAppContext>(options =>
{
    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection")
        ?? builder.Configuration.GetConnectionString("OracleConnection");

    if (string.IsNullOrWhiteSpace(connectionString))
    {
        throw new InvalidOperationException("No se encontró la cadena de conexión de Oracle. Define 'DefaultConnection' o 'OracleConnection'.");
    }

    options.UseOracle(connectionString);
});

// Construye la aplicación con la configuración definida.
var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Redirige las peticiones HTTP a HTTPS y registra los endpoints de los controladores.
app.UseHttpsRedirection();
app.MapControllers();

app.Run();
