using Shopping.Domain.DTOs;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shopping.Domain.Mappers
{
    public static class UserMapper
    {
        // Méthode d'extension pour mapper le résultat de la SP
        public static UserLoginResult ToUserLoginResult(this IDataRecord dr)
        {
            return new UserLoginResult
            {
                UserId = (Guid)dr["UserId"],
                Username = (string)dr["Username"],
                Email = (string)dr["Email"],
                RoleName = (string)dr["RoleName"]
            };
        }
        public static UserAdminViewDTO ToUserAdminView(this IDataRecord dr)
        {
            return new UserAdminViewDTO
            {
                UserId = (Guid)dr["UserId"],
                Username = (string)dr["Username"],
                Email = (string)dr["Email"],
                RoleName = (string)dr["RoleName"],
                CreatedAt = (DateTime)dr["CreatedAt"],
                // Gère le cas où DisableAt est NULL dans la base de données
                DisableAt = dr["DisableAt"] == DBNull.Value ? null : (DateTime?)dr["DisableAt"]
            };
        }
    }
}
