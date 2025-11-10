using Shopping.Domain.Commands;
using Shopping.Domain.DTOs;
using Shopping.Domain.Queries;
using Shopping.Tools.CQS.Queries;
using System.Collections.Generic;
using Shopping.Tools.CQS;
using Shopping.Tools.CQS.Commands;

namespace Shopping.Domain.Repositories
{
    public interface IShoppingListRepository :
        IQueryHandler<ShoppingListQueryGetAll, IEnumerable<ShoppingListSummaryDTO>>,
        IQueryHandler<ShoppingListQueryGetItems, IEnumerable<ShoppingListItemDTO>>,
        ICommandHandler<ShoppingListCommandCreate,Guid>,
        ICommandHandler<ShoppingListCommandDelete>,

        ICommandHandler<UserItemCommandCreate,Guid>,
        ICommandHandler<UserItemCommandUpdateCheck>,
        ICommandHandler<UserItemCommandDelete>,
        ICommandHandler<UserItemCommandUpdate>

    {
    }
}