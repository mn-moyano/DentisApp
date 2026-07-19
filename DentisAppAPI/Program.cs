using System.Text.Json.Serialization;

// Configura la API web y sus servicios principales.
var builder = WebApplication.CreateBuilder(args);

// Habilita los controladores y la documentación OpenAPI para la API.
builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.ConfigureHttpJsonOptions(options =>
{
    // Convierte las propiedades a formato camelCase y omite los valores nulos en la respuesta.
    options.SerializerOptions.PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase;
    options.SerializerOptions.DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull;
});

// Construye la aplicación con la configuración definida.
var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    // Expone la documentación OpenAPI al ejecutar la API en modo desarrollo.
    app.MapOpenApi();
}

// Redirige las peticiones HTTP a HTTPS y registra los endpoints de los controladores.
app.UseHttpsRedirection();
app.MapControllers();

app.Run();
