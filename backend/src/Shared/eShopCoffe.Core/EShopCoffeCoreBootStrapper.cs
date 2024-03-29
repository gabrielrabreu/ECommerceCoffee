﻿using eShopCoffe.Core.Cryptography;
using eShopCoffe.Core.Cryptography.Interfaces;
using eShopCoffe.Core.Domain.Repositories;
using eShopCoffe.Core.Domain.Repositories.Interfaces;
using eShopCoffe.Core.Email;
using eShopCoffe.Core.Email.Interfaces;
using eShopCoffe.Core.Messaging.Bus;
using eShopCoffe.Core.Messaging.Bus.Interfaces;
using eShopCoffe.Core.Messaging.Dispatchers;
using eShopCoffe.Core.Messaging.Dispatchers.Interfaces;
using eShopCoffe.Core.Messaging.Handlers;
using eShopCoffe.Core.Messaging.Handlers.Interfaces;
using eShopCoffe.Core.Security;
using eShopCoffe.Core.Security.Interfaces;
using Microsoft.Extensions.DependencyInjection;

namespace eShopCoffe.Core
{
    public static class EShopCoffeCoreBootStrapper
    {
        public static void ConfigureServices(IServiceCollection services)
        {
            Bus(services);
            Dispatchers(services);
            Notifications(services);
            Session(services);
            Repositories(services);
            Cryptography(services);
            Email(services);
        }

        private static void Bus(IServiceCollection services)
        {
            services.AddScoped<IBus, MemoryBus>();
        }

        private static void Dispatchers(IServiceCollection services)
        {
            services.AddScoped<ICommandDispatcher, CommandDispatcher>();
            services.AddScoped<IQueryDispatcher, QueryDispatcher>();
            services.AddScoped<IEventDispatcher, EventDispatcher>();
        }

        private static void Notifications(IServiceCollection services)
        {
            services.AddScoped<INotificationHandler, NotificationHandler>();
        }

        private static void Session(IServiceCollection services)
        {
            services.AddScoped<ISessionAccessor, SessionAccessor>();
        }

        private static void Repositories(IServiceCollection services)
        {
            services.AddScoped<IRepository, Repository>();
        }

        private static void Cryptography(IServiceCollection services)
        {
            services.AddScoped<IPasswordHash, PasswordHash>();
        }

        private static void Email(IServiceCollection services)
        {
            services.AddScoped<IEmailSettings, EmailSettings>();
            services.AddScoped<IEmailService, EmailService>();
            services.AddScoped<IEmailSender, EmailSenderSmtp>();
        }
    }
}
