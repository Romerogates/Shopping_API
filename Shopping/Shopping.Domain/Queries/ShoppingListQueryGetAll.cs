using Shopping.Domain.DTOs;
using Shopping.Tools.CQS.Queries;
using Shopping.Tools.CQS;

namespace Shopping.Domain.Queries
{
    // Nom : [ShoppingList] + [Query] + [GetAll]
    public class ShoppingListQueryGetAll : IQueryDefinition<IEnumerable<ShoppingListSummaryDTO>>
    {
        // Sera fourni par l'API depuis le jeton (token)
        public Guid UserId { get; set; }
    }
}