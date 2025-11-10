using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims; // <-- Using Corrigé
using Shopping.API.DTOs;
using Shopping.Domain.Commands;
using Shopping.Domain.Repositories;
using System;

namespace Shopping.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class UserController : ControllerBase
    {
        private readonly IUserRepository _userRepository;

        public UserController(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        [HttpPut("username")]
        public IActionResult UpdateUsername([FromBody] UserRequestUpdateUsername request)
        {
            var userId = GetUserIdFromToken();
            if (userId == Guid.Empty)
            {
                return Unauthorized(new { message = "Jeton invalide ou session expirée." });
            }

            var command = new UserCommandUpdateUsername
            {
                UserId = userId,
                NewUsername = request.NewUsername
            };

            bool success = _userRepository.Execute(command);

            if (success)
            {
                return Ok(new { message = "Nom d'utilisateur mis à jour." });
            }
            else
            {
                return Conflict(new { message = "Ce nom d'utilisateur est peut-être déjà pris." });
            }
        }

        // --- MÉTHODE DE LECTURE DU JETON (Token) CORRIGÉE ---
        private Guid GetUserIdFromToken()
        {
            // 'Sub' (de TokenService) est mappé en 'NameIdentifier' par le middleware
            var userIdString = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (Guid.TryParse(userIdString, out Guid userId))
            {
                return userId;
            }
            return Guid.Empty;
        }
    }
}