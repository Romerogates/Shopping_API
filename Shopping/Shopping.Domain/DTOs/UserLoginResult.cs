using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shopping.Domain.DTOs
{
    // C'est l'objet que la procédure SP_USER_USER_login va nous renvoyer.
    // Ce n'est pas une entité, juste un conteneur de données.
    public class UserLoginResult
    {
        public Guid UserId { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string RoleName { get; set; } // Vient de notre JOIN
    }
}
