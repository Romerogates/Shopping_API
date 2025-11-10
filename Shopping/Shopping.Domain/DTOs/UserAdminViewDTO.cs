namespace Shopping.Domain.DTOs
{
    /// <summary>
    /// DTO représentant les informations d'un utilisateur
    /// vues par un administrateur.
    /// </summary>
    public class UserAdminViewDTO
    {
        public Guid UserId { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string RoleName { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? DisableAt { get; set; } // Nullable si l'utilisateur est actif
    }
}