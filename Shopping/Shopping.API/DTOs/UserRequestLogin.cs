namespace Shopping.API.DTOs
{
    /// <summary>
    /// DTO pour la requête API de connexion
    /// Nom: [User] + [Request] + [Login]
    /// </summary>
    public class UserRequestLogin
    {
        public string LoginIdentifier { get; set; }
        public string Password { get; set; }
    }
}