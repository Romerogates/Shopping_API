using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Shopping.API.DTOs;
using Shopping.Domain.Commands;
using Shopping.Domain.Queries;
using Shopping.Domain.Repositories;
using System.Collections.Generic;
using System;

namespace Shopping.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = "Admin")] // Sécurisé pour les Admins
    public class AdminController : ControllerBase
    {
        private readonly IUserRepository _userRepository;

        public AdminController(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        [HttpGet("users")]
        public IActionResult GetAllUsers()
        {
            var query = new UserQueryGetAll();
            var users = _userRepository.Execute(query);
            return Ok(users);
        }

        [HttpPatch("users/{id}")]
        public IActionResult UpdateUser(Guid id, [FromBody] UserRequestAdminUpdate request)
        {
            var command = new UserCommandAdminUpdate
            {
                UserId = id,
                Username = request.Username,
                Email = request.Email,
                Role = request.Role,
                DisableStatus = request.DisableStatus
            };

            bool success = _userRepository.Execute(command);

            if (success)
            {
                return Ok(new { message = "Utilisateur mis à jour avec succès." });
            }
            else
            {
                return Conflict(new { message = "Impossible de mettre à jour l'utilisateur." });
            }
        }
    }
}