namespace Shopping.API.DTOs
{
    public class UserItemRequestUpdate
    {
        public string Name { get; set; }
        public decimal Quantity { get; set; }
        public int? UnitId { get; set; } // <-- MODIFIÉ (était string Unit)
    }
}