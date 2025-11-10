namespace Shopping.API.DTOs
{
    /// <summary>
    /// DTO pour la réponse API de connexion
    /// Nom: [User] + [Response] + [Login]
    /// </summary>
    public class UserResponseLogin
    {
        public string Token { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string Role { get; set; }
    }
}