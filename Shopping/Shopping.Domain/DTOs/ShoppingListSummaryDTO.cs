namespace Shopping.Domain.DTOs
{
    // Résultat de SP_USER_LIST_getAll
    public class ShoppingListSummaryDTO
    {
        public Guid ListId { get; set; }
        public string Name { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}