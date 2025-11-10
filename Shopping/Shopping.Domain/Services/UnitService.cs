using System.Data.Common;
using System.Linq;
using System.Collections.Generic;
using Shopping.Domain.Repositories;
using Shopping.Domain.Queries;
using Shopping.Domain.DTOs;
using Shopping.Tools.Database;
using Shopping.Domain.Mappers;

namespace Shopping.Domain.Services
{
    public class UnitService : IUnitRepository
    {
        private readonly DbConnection _dbConnection;
        public UnitService(DbConnection dbConnection) { _dbConnection = dbConnection; }

        public IEnumerable<UnitDTO> Execute(UnitQueryGetAll query)
        {
            return _dbConnection.ExecuteReader(
                "SP_UNIT_getAll",
                dr => dr.ToUnitDTO(),
                isStoredProcedure: true
            ).ToList();
        }
    }
}