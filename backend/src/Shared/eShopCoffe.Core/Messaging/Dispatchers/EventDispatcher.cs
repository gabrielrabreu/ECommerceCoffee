﻿using eShopCoffe.Core.Messaging.Dispatchers.Interfaces;
using eShopCoffe.Core.Messaging.Handlers.Interfaces;
using eShopCoffe.Core.Messaging.Requests.Interfaces;
using Microsoft.Extensions.DependencyInjection;

namespace eShopCoffe.Core.Messaging.Dispatchers
{
    public class EventDispatcher : IEventDispatcher
    {
        private readonly IServiceProvider _serviceProvider;

        public EventDispatcher(IServiceProvider serviceProvider)
        {
            _serviceProvider = serviceProvider;
        }

        public Task Dispatch<TEvent>(TEvent @event, CancellationToken cancellationToken = default) where TEvent : IEvent
        {
            var handler = _serviceProvider.GetRequiredService<IEventHandler<TEvent>>();
            return handler.Handle(@event, cancellationToken);
        }
    }
}
