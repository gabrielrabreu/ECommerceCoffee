﻿using eShopCoffe.Core.Data.Adapters;
using eShopCoffe.Identity.Domain.Entities;
using eShopCoffe.Identity.Infra.Data.Adapters.Interfaces;
using eShopCoffe.Identity.Infra.Data.Entities;

namespace eShopCoffe.Identity.Infra.Data.Adapters
{
    public class UserDataAdapter : DataAdapter<UserDomain, UserData>, IUserDataAdapter
    {
        public override UserDomain? Transform(UserData? data)
        {
            if (data == null) return null;

            return new UserDomain(data.Id, data.Login, data.Password, data.IsAdmin);
        }

        public override UserData? Transform(UserDomain? domain)
        {
            if (domain == null) return null;

            return new UserData()
            {
                Id = domain.Id,
                Login = domain.Login,
                Password = domain.Password,
                IsAdmin = domain.IsAdmin
            };
        }
    }
}