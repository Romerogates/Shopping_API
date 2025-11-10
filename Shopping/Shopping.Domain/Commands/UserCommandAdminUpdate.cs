using Shopping.Tools.CQS.Commands;
using System;
using Shopping.Tools.CQS; // Pour ICommandDefinition

namespace Shopping.Domain.Commands
{
    /// <summary>
    /// Commande CQS pour la mise à jour admin d'un utilisateur.
    /// Nom : [User] + [Command] + [AdminUpdate]
    /// </summary>
    public class UserCommandAdminUpdate : ICommandDefinition
    {
        // 'Qui' mettre à jour
        public Guid UserId { get; set; }

        // Les nouveaux détails (null si inchangés)
        public string Username { get; set; }
        public string Email { get; set; }
        public int? Role { get; set; } // Nullable int
        public bool? DisableStatus { get; set; } // Nullable bool
    }
}