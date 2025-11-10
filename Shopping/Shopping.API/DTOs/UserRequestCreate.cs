namespace Shopping.API.DTOs
{
    /// <summary>
    /// DTO pour la requête API de création d'utilisateur.
    /// Nom : [User] + [Request] + [Create]
    /// </summary>
    public class UserRequestCreate
    {
        public string Username { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
    }
}