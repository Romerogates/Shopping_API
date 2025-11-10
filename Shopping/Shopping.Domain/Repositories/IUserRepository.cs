using Shopping.Domain.Commands;
using Shopping.Domain.DTOs;
using Shopping.Domain.Queries;
using Shopping.Tools.CQS.Commands;
using Shopping.Tools.CQS.Queries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shopping.Domain.Repositories
{
    public interface IUserRepository :

        IQueryHandler<UserQueryLogin, UserLoginResult?>,
        IQueryHandler<UserQueryGetAll,IEnumerable<UserAdminViewDTO>>,


        ICommandHandler<UserCommandAdminUpdate>,
        ICommandHandler<UserCommandUpdateUsername>,
        ICommandHandler<UserCommandCreate>
    { }
  
}
