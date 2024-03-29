﻿using eShopCoffe.Identity.Domain.Entities;
using eShopCoffe.Identity.Infra.Data.Adapters;
using eShopCoffe.Identity.Infra.Data.Entities;

namespace eShopCoffe.Identity.Infra.Data.Tests.Adapters
{
    public class UserDataAdapterTests
    {
        private readonly UserDataAdapter _adapter;

        public UserDataAdapterTests()
        {
            _adapter = new UserDataAdapter();
        }

        [Fact]
        public void Transform_DomainToData_WhenNull_ShouldReturnNull()
        {
            // Arrange
            UserDomain? domain = null;

            // Act
            var data = _adapter.Transform(domain);

            // Assert
            data.Should().BeNull();
        }

        [Fact]
        public void Transform_DomainToData_WhenNotNull_ShouldReturnData()
        {
            // Arrange
            var domain = new UserDomain(Guid.NewGuid(), "Username", "Email", true);

            // Act
            var data = _adapter.Transform(domain);

            // Assert
            data.Should().NotBeNull();
            if (data == null) return;

            data.Id.Should().Be(domain.Id);
            data.Username.Should().Be(domain.Username);
            data.Email.Should().Be(domain.Email);
            data.HashedPassword.Should().BeEmpty();
            data.IsAdmin.Should().Be(domain.IsAdmin);
        }

        [Fact]
        public void Transform_DataToDomain_WhenNull_ShouldReturnNull()
        {
            // Arrange
            UserData? data = null;

            // Act
            var domain = _adapter.Transform(data);

            // Assert
            domain.Should().BeNull();
        }

        [Fact]
        public void Transform_DataToDomain_WhenNotNull_ShouldReturnDomain()
        {
            // Arrange
            var data = new UserData()
            {
                Id = Guid.NewGuid(),
                Username = "Username",
                HashedPassword = "Password",
                IsAdmin = true
            };

            // Act
            var domain = _adapter.Transform(data);

            // Assert
            domain.Should().NotBeNull();
            if (domain == null) return;

            domain.Id.Should().Be(data.Id);
            domain.Username.Should().Be(data.Username);
            domain.Email.Should().Be(data.Email);
            domain.HashedPassword.Should().BeEmpty();
            domain.IsAdmin.Should().Be(data.IsAdmin);
        }
    }
}
