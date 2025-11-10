using System.Data.Common;
using Shopping.Domain.Repositories;
using Shopping.Domain.Queries;
using Shopping.Domain.Commands;
using Shopping.Tools.Database;
using System.Linq;
using Shopping.Domain.Mappers;
using Shopping.Domain.DTOs;
using System.Collections.Generic; // Pour IEnumerable
using System; // Pour Exception

namespace Shopping.Domain.Services
{
    public class UserService : IUserRepository
    {
        private readonly DbConnection _dbConnection;

        public UserService(DbConnection dbConnection)
        {
            _dbConnection = dbConnection;
        }

        public UserLoginResult? Execute(UserQueryLogin query)
        {
            var result = _dbConnection.ExecuteReader(
                "SP_USER_USER_login",
                dr => dr.ToUserLoginResult(),
                query,
                isStoredProcedure: true
            );
            return result.SingleOrDefault();
        }

        public bool Execute(UserCommandCreate command)
        {
            try
            {
                _dbConnection.ExecuteNonQuery(
                    "SP_USER_USER_create",
                    isStoredProcedure: true,
                    parameters: command
                );
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public bool Execute(UserCommandUpdateUsername command)
        {
            try
            {
                _dbConnection.ExecuteNonQuery(
                    "SP_USER_USER_update",
                    isStoredProcedure: true,
                    parameters: command
                );
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public IEnumerable<UserAdminViewDTO> Execute(UserQueryGetAll query)
        {
            return _dbConnection.ExecuteReader(
                "SP_ADMIN_USER_getAll",
                dr => dr.ToUserAdminView(),
                isStoredProcedure: true
            ).ToList();
        }

        public bool Execute(UserCommandAdminUpdate command)
        {
            try
            {
                _dbConnection.ExecuteNonQuery(
                    "SP_ADMIN_USER_update",
                    isStoredProcedure: true,
                    parameters: command
                );
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}