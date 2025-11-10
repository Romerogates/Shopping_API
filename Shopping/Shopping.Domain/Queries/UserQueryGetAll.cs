using Shopping.Domain.DTOs;
using Shopping.Tools.CQS.Queries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shopping.Domain.Queries
{
    public class UserQueryGetAll : IQueryDefinition<IEnumerable<UserAdminViewDTO>>
    {
    }
}
