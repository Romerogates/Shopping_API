using Shopping.Tools.CQS;
using Shopping.Tools.CQS.Commands;
using System;

namespace Shopping.Domain.Commands
{
    /// <summary>
    /// Commande pour créer une nouvelle liste de courses.
    /// Nom : [ShoppingList] + [Command] + [Create]
    /// Elle est un ICommandDefinition qui retourne le Guid (ListId) créé.
    /// </summary>
    public class ShoppingListCommandCreate : ICommandDefinition<Guid>
    {
        public Guid UserId { get; set; }
        public string Name { get; set; }
    }
}