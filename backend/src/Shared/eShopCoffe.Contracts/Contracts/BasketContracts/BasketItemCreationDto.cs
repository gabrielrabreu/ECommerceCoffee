﻿namespace eShopCoffe.Contracts.Contracts.BasketContracts
{
    public class BasketItemCreationDto
    {
        public Guid ProductId { get; set; }
        public int Amount { get; set; }
        public bool Increase { get; set; }
    }
}
