using CommandLine;

namespace TGC.GitHubSecretConsole;

internal class Program
{
	static async Task Main(string[] args)
	{
		var parser = new Parser();
		var result = parser.ParseArguments<CommandlineOptions>(args);

		await result.MapResult(
			async commandLineOptions => await CreateRepositorySecret(commandLineOptions),
			errors => Task.FromResult(0)
		);
	}

	static async Task CreateRepositorySecret(CommandlineOptions repositoryDefinition)
	{
		using (GithubRepositoryHttpClient githubHttpClient = new GithubRepositoryHttpClient(repositoryDefinition.PersonalAccessToken, repositoryDefinition.Owner, repositoryDefinition.Repository))
		{
			try
			{
				var publicKey = await githubHttpClient.GetPublicKey();

				ArgumentNullException.ThrowIfNull(publicKey);
				ArgumentException.ThrowIfNullOrEmpty(publicKey.Key);
				ArgumentException.ThrowIfNullOrEmpty(publicKey.KeyId);

				var encryptedValue = EncryptMessage(repositoryDefinition.SecretPayload, publicKey.Key);

				await githubHttpClient.UpsertRepositorySecret(repositoryDefinition.SecretName, encryptedValue, publicKey.KeyId);
			}
			catch (HttpRequestException ex)
			{
				Console.WriteLine($"HTTP request error: {ex.Message}");
			}
		}
	}

	public static string EncryptMessage(string message, string key)
	{
		var secretValue = System.Text.Encoding.UTF8.GetBytes(message);
		var publicKey = Convert.FromBase64String(key);

		var sealedPublicKeyBox = Sodium.SealedPublicKeyBox.Create(secretValue, publicKey);

		return Convert.ToBase64String(sealedPublicKeyBox);
	}
}