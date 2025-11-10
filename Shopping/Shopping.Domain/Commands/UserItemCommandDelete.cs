using Shopping.Tools.CQS.Commands;
using System;
using Shopping.Tools.CQS; // (Ou Tools.CQS.Commands)

namespace Shopping.Domain.Commands
{
    public class UserItemCommandDelete : ICommandDefinition
    {
        public Guid ItemId { get; set; }
        public Guid UserId { get; set; } // Sécurité
    }
}