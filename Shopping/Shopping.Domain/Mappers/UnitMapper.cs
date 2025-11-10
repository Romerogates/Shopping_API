using System.Data;
using Shopping.Domain.DTOs;

namespace Shopping.Domain.Mappers
{
    public static class UnitMapper
    {
        public static UnitDTO ToUnitDTO(this IDataRecord dr)
        {
            return new UnitDTO
            {
                UnitId = (int)dr["UnitId"], // <-- MODIFIÉ
                Name = (string)dr["Name"]
            };
        }
    }
}