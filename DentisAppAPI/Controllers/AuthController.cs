using DentisAppAPI.DTOs.Auth;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace DentisAppAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly IWebHostEnvironment _environment;
        private readonly IMemoryCache _cache;

        public AuthController(
            IConfiguration config,
            IWebHostEnvironment environment,
            IMemoryCache cache)
        {
            _config = config;
            _environment = environment;
            _cache = cache;
        }

        // ============================================================
        // LOGIN
        // ============================================================

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

            // Generar JWT
            var tokenString = GenerarAccessToken(request.Username);

            // Generar refresh token
            var refreshToken = GenerarRefreshToken();

            // Guardar el refresh token temporalmente en memoria.
            GuardarRefreshToken(
                refreshToken,
                request.Username
            );

            return Ok(new
            {
                success = true,
                message = "Inicio de sesión correcto.",
                token = tokenString,
                refreshToken = refreshToken
            });
        }

        // ============================================================
        // REFRESH TOKEN
        // ============================================================

        [HttpPost("refresh")]
        public IActionResult Refresh([FromBody] RefreshTokenRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.RefreshToken))
            {
                return Unauthorized(new
                {
                    success = false,
                    message = "El refresh token es obligatorio."
                });
            }

            // Buscar el refresh token en memoria.
            var cacheKey = $"refresh_token:{request.RefreshToken}";

            if (!_cache.TryGetValue(cacheKey, out string? username) ||
                string.IsNullOrWhiteSpace(username))
            {
                return Unauthorized(new
                {
                    success = false,
                    message = "El refresh token no es válido o ha expirado."
                });
            }

            // El refresh token utilizado queda invalidado.
            _cache.Remove(cacheKey);

            // Generar un nuevo access token.
            var newToken = GenerarAccessToken(username);

            // Generar un nuevo refresh token.
            var newRefreshToken = GenerarRefreshToken();

            // Guardar el nuevo refresh token.
            GuardarRefreshToken(
                newRefreshToken,
                username
            );

            return Ok(new
            {
                success = true,
                message = "Token renovado correctamente.",
                token = newToken,
                refreshToken = newRefreshToken
            });
        }

        // ============================================================
        // GENERAR ACCESS TOKEN
        // ============================================================

        private string GenerarAccessToken(string username)
        {
            var jwtSettings = _config.GetSection("Jwt");

            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(
                    jwtSettings["Key"]!
                )
            );

            var credentials = new SigningCredentials(
                key,
                SecurityAlgorithms.HmacSha256
            );

            var claims = new[]
            {
                new Claim(
                    ClaimTypes.Name,
                    username
                ),

                new Claim(
                    ClaimTypes.Role,
                    "Administrador"
                )
            };

            // Permite controlar la duración desde appsettings.
            var accessTokenMinutes =
                jwtSettings.GetValue<int?>("AccessTokenExpirationMinutes") ?? 60;

            var token = new JwtSecurityToken(
                issuer: jwtSettings["Issuer"],
                audience: jwtSettings["Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(
                    accessTokenMinutes
                ),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler()
                .WriteToken(token);
        }

        // ============================================================
        // GENERAR REFRESH TOKEN
        // ============================================================

        private string GenerarRefreshToken()
        {
            var bytes = RandomNumberGenerator.GetBytes(32);

            return Convert.ToBase64String(bytes)
                .Replace("+", "-")
                .Replace("/", "_")
                .Replace("=", "");
        }

        // ============================================================
        // GUARDAR REFRESH TOKEN
        // ============================================================

        private void GuardarRefreshToken(
            string refreshToken,
            string username)
        {
            var jwtSettings = _config.GetSection("Jwt");

            var refreshTokenDays =
                jwtSettings.GetValue<int?>("RefreshTokenDays") ?? 7;

            var cacheKey = $"refresh_token:{refreshToken}";

            _cache.Set(
                cacheKey,
                username,
                TimeSpan.FromDays(refreshTokenDays)
            );
        }
    }
}