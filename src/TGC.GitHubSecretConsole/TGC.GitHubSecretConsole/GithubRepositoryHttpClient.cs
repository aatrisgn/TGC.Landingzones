using System.Text;
using System.Text.Json;
using TGC.GitHubSecretConsole.Models;

namespace TGC.GitHubSecretConsole;

public class GithubRepositoryHttpClient : HttpClient
{
	private readonly string repositoryOwner;
	private readonly string repositoryName;

	public GithubRepositoryHttpClient(string personalAccessToken, string repositoryOwner, string repositoryName)
	{
		this.repositoryName = repositoryName;
		this.repositoryOwner = repositoryOwner;

		BaseAddress = new Uri("https://api.github.com/");

		DefaultRequestHeaders.Add("Authorization", $"Bearer {personalAccessToken}");
		DefaultRequestHeaders.Add("X-GitHub-Api-Version", "2022-11-28");
		DefaultRequestHeaders.Add("Accept", "application/vnd.github+json");
		DefaultRequestHeaders.Add("User-Agent", "MyGitHubApiClient");
	}

	public async Task<PublicKeyResponse> GetPublicKey()
	{
		string endpoint = $"repos/{repositoryOwner}/{repositoryName}/actions/secrets/public-key";

		HttpResponseMessage response = await GetAsync(endpoint);

		response.EnsureSuccessStatusCode();

		var jsonResponse = await response.Content.ReadAsStringAsync();
		var typedResponse = JsonSerializer.Deserialize<PublicKeyResponse>(jsonResponse);

		if (typedResponse != null)
		{
			return typedResponse;
		}

		throw new Exception("Deserialization of public-key response was null");
	}

	public async Task UpsertRepositorySecret(string secretName, string secretValue, string publicKeyId)
	{
		string secretEndpoint = $"repos/{repositoryOwner}/{repositoryName}/actions/secrets/{secretName}";

		string jsonContent = JsonSerializer.Serialize(new RepositorySecretRequest(secretValue, publicKeyId));
		StringContent content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

		var secretResponse = await PutAsync(secretEndpoint, content);
		secretResponse.EnsureSuccessStatusCode();
	}
}
