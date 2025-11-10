using Shopping.Domain.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shopping.Domain.Repositories
{
    public interface ITokenService
    {
        string GenerateToken(UserLoginResult user);
    }
}
