using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims; // <-- Using Corrigé
using Shopping.Domain.Repositories;
using Shopping.Domain.Queries;
using Shopping.Domain.Commands;
using Shopping.API.DTOs;
using System;
using System.Collections.Generic;


namespace Shopping.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ShoppingListController : ControllerBase
    {
        private readonly IShoppingListRepository _listRepository;

        public ShoppingListController(IShoppingListRepository listRepository)
        {
            _listRepository = listRepository;
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

        [HttpGet]
        public IActionResult GetAllLists()
        {
            var userId = GetUserIdFromToken();
            if (userId == Guid.Empty) return Unauthorized(new { message = "Jeton invalide." });

            var query = new ShoppingListQueryGetAll { UserId = userId };
            var lists = _listRepository.Execute(query);
            return Ok(lists);
        }

        [HttpGet("{listId:guid}")]
        public IActionResult GetListItems(Guid listId)
        {
            var userId = GetUserIdFromToken();
            if (userId == Guid.Empty) return Unauthorized(new { message = "Jeton invalide." });

            var query = new ShoppingListQueryGetItems { ListId = listId, UserId = userId };
            try
            {
                var items = _listRepository.Execute(query);
                return Ok(items);
            }
            catch (Exception ex) when (ex.Message.Contains("accès non autorisé"))
            {
                return NotFound(new { message = ex.Message });
            }
        }

        [HttpPost]
        public IActionResult CreateList([FromBody] ShoppingListRequestCreate request)
        {
            var userId = GetUserIdFromToken();
            if (userId == Guid.Empty) return Unauthorized(new { message = "Jeton invalide." });

            var command = new ShoppingListCommandCreate { UserId = userId, Name = request.Name };
            try
            {
                var newListId = _listRepository.Execute(command);
                return CreatedAtAction(nameof(GetListItems), new { listId = newListId }, new { ListId = newListId, Name = request.Name });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Erreur lors de la création de la liste: " + ex.Message });
            }
        }

        [HttpPost("{listId:guid}/item")]
        public IActionResult AddItem(Guid listId, [FromBody] ShoppingListItemRequestCreate request)
        {
            var userId = GetUserIdFromToken();
            if (userId == Guid.Empty) return Unauthorized(new { message = "Jeton invalide." });

            var command = new UserItemCommandCreate { ListId = listId, UserId = userId, Name = request.Name, Quantity = request.Quantity, UnitId = request.UnitId };
            try
            {
                var newItemId = _listRepository.Execute(command);
                return Created($"/api/shoppinglist/{listId}/item/{newItemId}", new { ItemId = newItemId, Name = request.Name });
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("accès refusé"))
                {
                    return NotFound(new { message = ex.Message });
                }
                return StatusCode(500, new { message = "Erreur lors de l'ajout de l'article: " + ex.Message });
            }
        }

        [HttpPatch("item/{itemId:guid}")]
        public IActionResult UpdateItemCheckStatus(Guid itemId, [FromBody] UserItemRequestUpdateCheck request)
        {
            var userId = GetUserIdFromToken();
            if (userId == Guid.Empty) return Unauthorized(new { message = "Jeton invalide." });

            var command = new UserItemCommandUpdateCheck { ItemId = itemId, UserId = userId, IsChecked = request.IsChecked };
            try
            {
                bool success = _listRepository.Execute(command);
                if (success) return NoContent();
                return NotFound(new { message = "Article non trouvé." });
            }
            catch (Exception)
            {
                return NotFound(new { message = "Article non trouvé ou accès refusé." });
            }
        }

        [HttpPut("item/{itemId:guid}")]
        public IActionResult UpdateItem(Guid itemId, [FromBody] UserItemRequestUpdate request)
        {
            var userId = GetUserIdFromToken();
            if (userId == Guid.Empty) return Unauthorized(new { message = "Jeton invalide." });

            var command = new UserItemCommandUpdate { ItemId = itemId, UserId = userId, Name = request.Name, Quantity = request.Quantity, UnitId = request.UnitId };
            try
            {
                bool success = _listRepository.Execute(command);
                if (success) return NoContent();
                return NotFound(new { message = "Article non trouvé ou accès refusé." });
            }
            catch (Exception)
            {
                return NotFound(new { message = "Article non trouvé ou accès refusé." });
            }
        }

        [HttpDelete("item/{itemId:guid}")]
        public IActionResult DeleteItem(Guid itemId)
        {
            var userId = GetUserIdFromToken();
            if (userId == Guid.Empty) return Unauthorized(new { message = "Jeton invalide." });

            var command = new UserItemCommandDelete { ItemId = itemId, UserId = userId };
            try
            {
                bool success = _listRepository.Execute(command);
                if (success) return NoContent();
                return NotFound(new { message = "Article non trouvé ou accès refusé." });
            }
            catch (Exception)
            {
                return NotFound(new { message = "Article non trouvé ou accès refusé." });
            }
        }

        [HttpDelete("{listId:guid}")]
        public IActionResult DeleteList(Guid listId)
        {
            var userId = GetUserIdFromToken();
            if (userId == Guid.Empty) return Unauthorized(new { message = "Jeton invalide." });

            var command = new ShoppingListCommandDelete { ListId = listId, UserId = userId };
            try
            {
                bool success = _listRepository.Execute(command);
                if (success) return NoContent();
                return NotFound(new { message = "Liste non trouvée ou accès refusé." });
            }
            catch (Exception)
            {
                return NotFound(new { message = "Liste non trouvée ou accès refusé." });
            }
        }
    }
}