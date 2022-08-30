﻿using Framework.Core.Messaging.Requests;
using Framework.Core.Validators;
using Identity.Domain.Validators.UserValidators;

namespace Identity.Domain.Commands.UserCommands
{
    public class UpdateUserCommand : ValidatableCommand<UpdateUserCommand>
    {
        public Guid Id { get; private set; }
        public string Login { get; private set; }
        public string Password { get; private set; }

        public UpdateUserCommand(Guid id, string login, string password)
        {
            Id = id;
            Login = login;
            Password = password;
        }

        public override CommandValidator<UpdateUserCommand> GetValidator()
        {
            return new UpdateUserCommandValidator();
        }
    }
}
