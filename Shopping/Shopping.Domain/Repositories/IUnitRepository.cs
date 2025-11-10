using Shopping.Domain.DTOs;
using Shopping.Domain.Queries;
using Shopping.Tools.CQS.Queries;
using System.Collections.Generic;
using Shopping.Tools.CQS;

namespace Shopping.Domain.Repositories
{
    public interface IUnitRepository :
        IQueryHandler<UnitQueryGetAll, IEnumerable<UnitDTO>>
    {
    }
}