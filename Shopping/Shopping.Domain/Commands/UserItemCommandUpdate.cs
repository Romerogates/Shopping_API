using Shopping.Tools.CQS.Commands;
using System;

namespace Shopping.Domain.Commands
{
    public class UserItemCommandUpdate : ICommandDefinition
    {
        public Guid ItemId { get; set; }
        public Guid UserId { get; set; }
        public string Name { get; set; }
        public decimal Quantity { get; set; }
        public int? UnitId { get; set; } // <-- MODIFIÉ (était string Unit)
    }
}