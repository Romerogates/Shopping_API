namespace Shopping.Domain.DTOs
{
    public class ShoppingListItemDTO
    {
        public Guid ItemId { get; set; }
        public string Name { get; set; }
        public decimal Quantity { get; set; }
        public bool IsChecked { get; set; }

        public int? UnitId { get; set; } // <-- MODIFIÉ (ID)
        public string? UnitName { get; set; } // <-- MODIFIÉ (Nom depuis le JOIN)
    }
}