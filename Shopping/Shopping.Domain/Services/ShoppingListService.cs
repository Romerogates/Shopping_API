using System.Data.Common;
using System.Linq;
using System;
using System.Collections.Generic;
using Shopping.Domain.Repositories;
using Shopping.Domain.Queries;
using Shopping.Domain.Commands;
using Shopping.Domain.DTOs;
using Shopping.Tools.Database;
using Shopping.Domain.Mappers;

namespace Shopping.Domain.Services
{
    public class ShoppingListService : IShoppingListRepository
    {
        private readonly DbConnection _dbConnection;

        public ShoppingListService(DbConnection dbConnection)
        {
            _dbConnection = dbConnection;
        }

        public IEnumerable<ShoppingListSummaryDTO> Execute(ShoppingListQueryGetAll query)
        {
            var results = _dbConnection.ExecuteReader(
                "SP_USER_LIST_getAll",
                dr => dr.ToShoppingListSummary(),
                query,
                isStoredProcedure: true
            );
            return results.ToList();
        }

        public IEnumerable<ShoppingListItemDTO> Execute(ShoppingListQueryGetItems query)
        {
            var results = _dbConnection.ExecuteReader(
                "SP_USER_LIST_getById",
                dr => dr.ToShoppingListItemDTO(),
                query,
                isStoredProcedure: true
            );
            return results.ToList();
        }

        public Guid Execute(ShoppingListCommandCreate command)
        {
            var results = _dbConnection.ExecuteReader(
                "SP_USER_LIST_create",
                dr => (Guid)dr["ListId"],
                command,
                isStoredProcedure: true
            );
            Guid newListId = results.SingleOrDefault();
            if (newListId == Guid.Empty)
            {
                throw new InvalidOperationException("La création de la liste a échoué.");
            }
            return newListId;
        }

        public Guid Execute(UserItemCommandCreate command)
        {
            var results = _dbConnection.ExecuteReader(
                "SP_USER_ITEM_create",
                dr => (Guid)dr["ItemId"],
                command,
                isStoredProcedure: true
            );
            Guid newItemId = results.SingleOrDefault();
            if (newItemId == Guid.Empty)
            {
                throw new InvalidOperationException("L'ajout de l'article a échoué.");
            }
            return newItemId;
        }

        public bool Execute(UserItemCommandUpdateCheck command)
        {
            try
            {
                _dbConnection.ExecuteNonQuery(
                    "SP_USER_ITEM_updateCheck",
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

        public bool Execute(UserItemCommandUpdate command)
        {
            try
            {
                _dbConnection.ExecuteNonQuery(
                    "SP_USER_ITEM_update",
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

        public bool Execute(UserItemCommandDelete command)
        {
            try
            {
                _dbConnection.ExecuteNonQuery(
                    "SP_USER_ITEM_delete",
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

        public bool Execute(ShoppingListCommandDelete command)
        {
            try
            {
                _dbConnection.ExecuteNonQuery(
                    "SP_USER_LIST_delete",
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