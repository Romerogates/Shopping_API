using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Shopping.Tools.Database
{
    public static class DbConnectionExtensions
    {
        /// <summary>
        /// Exécute une commande et retourne la première colonne de la première ligne.
        /// </summary>
        public static object? ExecuteScalar(this DbConnection dbConnection, string commandText, bool isStoredProcedure = false, object? parameters = null)
        {
            using (DbCommand dbCommand = CreateCommand(dbConnection, commandText, isStoredProcedure, parameters))
            {
                object? result = dbCommand.ExecuteScalar();
                return result is DBNull ? null : result;
            }
        }

        /// <summary>
        /// Exécute une commande (INSERT, UPDATE, DELETE) ou une SP ne retournant pas de données.
        /// </summary>
        public static int ExecuteNonQuery(this DbConnection dbConnection, string commandText, bool isStoredProcedure = false, object? parameters = null)
        {
            using (DbCommand dbCommand = CreateCommand(dbConnection, commandText, isStoredProcedure, parameters))
            {
                return dbCommand.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Exécute une requête (SELECT) ou une SP et mappe les résultats.
        /// </summary>
        /// <param name="parameters">Les paramètres (objet anonyme ou CQS).</param>
        /// <param name="isStoredProcedure">Indique si le commandText est un nom de SP.</param>
        public static IEnumerable<TResult> ExecuteReader<TResult>(this DbConnection dbConnection, string commandText, Func<IDataRecord, TResult> mapper, object? parameters = null, bool isStoredProcedure = false)
        {
            using (DbCommand dbCommand = CreateCommand(dbConnection, commandText, isStoredProcedure, parameters))
            {
                using (DbDataReader dbDataReader = dbCommand.ExecuteReader())
                {
                    while (dbDataReader.Read())
                    {
                        yield return mapper(dbDataReader);
                    }
                }
            }
        }

        // --- Méthodes privées ---

        /// <summary>
        /// Crée une DbCommand, gère la connexion et mappe les paramètres.
        /// </summary>
        private static DbCommand CreateCommand(DbConnection dbConnection, string commandText, bool isStoredProcedure, object? parameters)
        {
            // S'assure que la connexion est ouverte
            EnsureDbConnection(dbConnection);

            DbCommand dbCommand = dbConnection.CreateCommand();
            dbCommand.CommandText = commandText;

            if (isStoredProcedure)
            {
                dbCommand.CommandType = CommandType.StoredProcedure;
            }

            if (parameters is not null)
            {
                foreach (PropertyInfo property in parameters.GetType().GetProperties().Where(p => p.CanRead))
                {
                    DbParameter dbParameter = dbCommand.CreateParameter();

                    // --- CORRECTION CRITIQUE ---
                    // Ajout du '@' pour correspondre aux noms de paramètres SQL
                    dbParameter.ParameterName = $"@{property.Name}";

                    dbParameter.Value = property.GetValue(parameters) ?? DBNull.Value;
                    dbCommand.Parameters.Add(dbParameter);
                }
            }

            return dbCommand;
        }

        /// <summary>
        /// Vérifie la connexion et l'ouvre si elle est fermée.
        /// </summary>
        private static void EnsureDbConnection(DbConnection dbConnection)
        {
            ArgumentNullException.ThrowIfNull(dbConnection);

            if (dbConnection.State == ConnectionState.Closed)
            {
                dbConnection.Open();
            }

            // S'assure qu'elle n'est pas dans un état cassé
            if (dbConnection.State != ConnectionState.Open)
            {
                throw new InvalidOperationException("La connexion à la base de données n'est pas ouverte.");
            }
        }
    }
}
