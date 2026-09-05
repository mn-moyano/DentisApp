using DentisAppAPI.DTOs.Auth;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace DentisAppAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly IWebHostEnvironment _environment;

        public AuthController(
            IConfiguration config,
            IWebHostEnvironment environment)
        {
            _config = config;
            _environment = environment;
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Username) ||
                string.IsNullOrWhiteSpace(request.Password))
            {
                return BadRequest(new
                {
                    success = false,
                    message = "El usuario y la contraseña son obligatorios."
                });
            }

            // El usuario demo solo existe durante el desarrollo local.
            if (!_environment.IsDevelopment() ||
                request.Username != "admin" ||
                request.Password != "1234")
            {
                return Unauthorized(new
                {
                    success = false,
                    message = "Usuario o contraseña incorrectos."
                });
            }

            var claims = new[]
            {
                new Claim(ClaimTypes.Name, request.Username),
                new Claim(ClaimTypes.Role, "Administrador")
            };

            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(
                    _config["Jwt:Key"]!
                )
            );

            var credentials = new SigningCredentials(
                key,
                SecurityAlgorithms.HmacSha256
            );

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddHours(1),
                signingCredentials: credentials
            );

            var tokenString =
                new JwtSecurityTokenHandler()
                    .WriteToken(token);

            return Ok(new
            {
                success = true,
                message = "Inicio de sesión correcto.",
                token = tokenString
            });
        }
    }
}