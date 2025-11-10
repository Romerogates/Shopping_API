namespace Shopping.API.DTOs
{
    /// <summary>
    /// DTO pour la requête API de mise à jour admin.
    /// Nom : [User] + [Request] + [AdminUpdate]
    /// </summary>
    public class UserRequestAdminUpdate
    {
        // Tous les champs sont optionnels
        public string Username { get; set; }
        public string Email { get; set; }
        public int? Role { get; set; }
        public bool? DisableStatus { get; set; }
    }
}