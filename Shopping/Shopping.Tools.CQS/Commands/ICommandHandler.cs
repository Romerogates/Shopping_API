
namespace Shopping.Tools.CQS.Commands
{
    // Handler pour les commandes sans retour (retourne bool)
    public interface ICommandHandler<TCommand> where TCommand : ICommandDefinition
    {
        bool Execute(TCommand command);
    }

    // Handler pour les commandes avec un résultat (votre solution pour ListId)
    public interface ICommandHandler<TCommand, TResult>
        where TCommand : ICommandDefinition<TResult>
    {
        TResult Execute(TCommand command);
    }
}