using Shopping.Domain.DTOs;
using Shopping.Tools.CQS.Queries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shopping.Domain.Queries
{
    public class UserQueryLogin : IQueryDefinition<UserLoginResult?>
    {
        public string LoginIdentifier { get; set; }
        public string Password { get; set; }
    }

}
