namespace Shopping.API.DTOs
{
    public class ShoppingListItemRequestCreate
    {
        public string Name { get; set; }
        public decimal Quantity { get; set; } = 1;
        public int? UnitId { get; set; } // <-- MODIFIÉ (était string Unit)
    }
}