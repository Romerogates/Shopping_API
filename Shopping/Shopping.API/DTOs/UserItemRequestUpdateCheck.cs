namespace Shopping.API.DTOs
{
    /// <summary>
    /// DTO pour la requête PATCH de mise à jour de l'état "coché".
    /// Nom : [User] + [Item] + [Request] + [UpdateCheck]
    /// </summary>
    public class UserItemRequestUpdateCheck
    {
        public bool IsChecked { get; set; }
    }
}