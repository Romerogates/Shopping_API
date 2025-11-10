using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Shopping.Domain.Repositories;
using Shopping.Domain.Queries;
using Shopping.Domain.Services;
using Shopping.API.DTOs;
using Shopping.Domain.Commands;

namespace Shopping.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IUserRepository _userRepository;
        private readonly ITokenService _tokenService;

        public AuthController(IUserRepository userRepository, ITokenService tokenService)
        {
            _userRepository = userRepository;
            _tokenService = tokenService;
        }

        [HttpPost("login")]
        [AllowAnonymous]
        public IActionResult Login([FromBody] UserRequestLogin request)
        {
            var query = new UserQueryLogin
            {
                LoginIdentifier = request.LoginIdentifier,
                Password = request.Password
            };

            var userResult = _userRepository.Execute(query);

            if (userResult is null)
            {
                return Unauthorized(new { message = "Identifiants invalides." });
            }

            var tokenString = _tokenService.GenerateToken(userResult);

            return Ok(new UserResponseLogin
            {
                Token = tokenString,
                Username = userResult.Username,
                Email = userResult.Email,
                Role = userResult.RoleName
            });
        }

        [HttpPost("register")]
        [AllowAnonymous]
        public IActionResult Register([FromBody] UserRequestCreate request)
        {
            var command = new UserCommandCreate
            {
                Username = request.Username,
                Email = request.Email,
                Password = request.Password,
                Role = 1 // Rôle utilisateur par défaut
            };

            bool success = _userRepository.Execute(command);

            if (success)
            {
                return StatusCode(201, new { message = "Utilisateur créé avec succès." });
            }
            else
            {
                return Conflict(new { message = "L'email ou le nom d'utilisateur existe déjà." });
            }
        }
    }
}