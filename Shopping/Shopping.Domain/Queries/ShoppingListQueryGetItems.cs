using Shopping.Domain.DTOs;
using Shopping.Tools.CQS.Queries;
using Shopping.Tools.CQS;

namespace Shopping.Domain.Queries
{
    // Nom : [ShoppingList] + [Query] + [GetItems]
    public class ShoppingListQueryGetItems : IQueryDefinition<IEnumerable<ShoppingListItemDTO>>
    {
        public Guid ListId { get; set; }
        // Sera fourni par l'API depuis le jeton (token)
        public Guid UserId { get; set; }
    }
}