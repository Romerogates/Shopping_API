using Shopping.Tools.CQS.Commands;
using Shopping.Tools.CQS; // Pour ICommandDefinition

namespace Shopping.Domain.Commands
{
    /// <summary>
    /// Commande CQS pour la création d'un utilisateur.
    /// Nom : [User] + [Command] + [Create]
    /// </summary>
    public class UserCommandCreate : ICommandDefinition
    {
        // Paramètres pour SP_USER_USER_create
        public string Username { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public int Role { get; set; } = 1; // <--- AJOUTER CECI avec la valeur par défaut

        // Note : Le 'Role' est géré par le DEFAULT 1 dans votre SP
    }
}
