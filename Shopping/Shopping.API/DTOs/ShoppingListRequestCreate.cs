namespace Shopping.API.DTOs
{
    public class ShoppingListRequestCreate
    {
        public string Name { get; set; }
        // Pas besoin de UserId, l'API le récupère du jeton
    }
}