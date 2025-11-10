using Shopping.Tools.CQS.Commands;
using System;
using Shopping.Tools.CQS;

namespace Shopping.Domain.Commands
{
    public class ShoppingListCommandDelete : ICommandDefinition
    {
        // VÉRIFIEZ CES PROPRIÉTÉS
        public Guid ListId { get; set; } // Doit s'appeler 'ListId'
        public Guid UserId { get; set; } // Doit s'appeler 'UserId'
    }
}