using System.Data;
using Shopping.Domain.DTOs;

namespace Shopping.Domain.Mappers
{
    // Créez ce nouveau fichier à côté de UserMapper.cs
    public static class ShoppingListMapper
    {
        public static ShoppingListSummaryDTO ToShoppingListSummary(this IDataRecord dr)
        {
            return new ShoppingListSummaryDTO
            {
                ListId = (Guid)dr["ListId"],
                Name = (string)dr["Name"],
                CreatedAt = (DateTime)dr["CreatedAt"]
            };
        }

        public static ShoppingListItemDTO ToShoppingListItemDTO(this IDataRecord dr)
        {
            return new ShoppingListItemDTO
            {
                ItemId = (Guid)dr["ItemId"],
                Name = (string)dr["Name"],
                Quantity = (decimal)dr["Quantity"],
                IsChecked = (bool)dr["IsChecked"],

                // --- MODIFIÉ ---
                UnitId = dr["UnitId"] == DBNull.Value ? null : (int?)dr["UnitId"],
                UnitName = dr["UnitName"] == DBNull.Value ? null : (string)dr["UnitName"]
            };
        }
    }
}