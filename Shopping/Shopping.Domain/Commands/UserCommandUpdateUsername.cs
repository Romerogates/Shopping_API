using Shopping.Tools.CQS.Commands;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shopping.Domain.Commands
{
    // Le nom respecte votre convention : [User] + [Command] + [UpdateUsername]
    public class UserCommandUpdateUsername : ICommandDefinition
    {
        // Les paramètres pour la SP restent les mêmes
        public Guid UserId { get; set; }
        public string NewUsername { get; set; }
    }
}
