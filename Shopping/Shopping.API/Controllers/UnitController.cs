using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Shopping.Domain.Repositories;
using Shopping.Domain.Queries;

namespace Shopping.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UnitController : ControllerBase
    {
        private readonly IUnitRepository _unitRepository;

        public UnitController(IUnitRepository unitRepository)
        {
            _unitRepository = unitRepository;
        }

        [HttpGet]
        [AllowAnonymous] // Tout le monde peut voir les unités
        public IActionResult GetAllUnits()
        {
            var query = new UnitQueryGetAll();
            var units = _unitRepository.Execute(query);
            return Ok(units);
        }
    }
}