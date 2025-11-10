using Shopping.Tools.CQS.Commands;
using System;

namespace Shopping.Domain.Commands
{
    public class UserItemCommandCreate : ICommandDefinition<Guid>
    {
        public Guid ListId { get; set; }
        public Guid UserId { get; set; }
        public string Name { get; set; }
        public decimal Quantity { get; set; } = 1;
        public int? UnitId { get; set; } // <-- MODIFIÉ (était string Unit)
    }
}