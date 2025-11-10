using Shopping.Tools.CQS.Commands;
using System;
using Shopping.Tools.CQS; 

namespace Shopping.Domain.Commands
{
    /// <summary>
    /// Commande pour mettre à jour l'état "coché" d'un article.
    /// Nom : [User] + [Item] + [Command] + [UpdateCheck]
    /// Implémente ICommandDefinition (retourne bool)
    /// </summary>
    public class UserItemCommandUpdateCheck : ICommandDefinition
    {
        public Guid ItemId { get; set; }
        public bool IsChecked { get; set; }
        public Guid UserId { get; set; } // Sécurité
    }
}