using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Options;
using TGC.Common.Serialization;
using TGC.GitHub.Models;

namespace TGC.GitHub;

public class GitHubService : IGitHubService
{
	private readonly HttpClient _httpClient;
	private readonly IJsonSerializer _jsonSerialiser;
	private readonly GitHubOptions _gitHubOptions;

	public GitHubService(HttpClient httpClient, IJsonSerializer jsonSerialiser, IOptions<GitHubOptions> gitHubOptions)
	{
		_httpClient = httpClient;
		_jsonSerialiser = jsonSerialiser;
		_gitHubOptions = gitHubOptions.Value;
	}

	public async Task<GitHubRepositoryResponse?> GetGitHubRepository(string repositoryName, bool failOnNotFound = false)
	{
		var existingRepositoryResponse = await _httpClient.GetAsync($"repos/{_gitHubOptions.Owner}/{repositoryName}");

		if (failOnNotFound)
		{
			existingRepositoryResponse.EnsureSuccessStatusCode();
			var content = await existingRepositoryResponse.Content.ReadAsStringAsync();
			var existingRepository = _jsonSerialiser.Deserialize<GitHubRepositoryResponse>(content);

			ArgumentNullException.ThrowIfNull(existingRepository);

			return existingRepository;
		}
		else
		{
			var content = await existingRepositoryResponse.Content.ReadAsStringAsync();
			return _jsonSerialiser.Deserialize<GitHubRepositoryResponse>(content);
		}
	}

	public async Task<bool> RepositoryExists(string repositoryName)
	{
		var existingRepositoryResponse = await GetGitHubRepository(repositoryName, false);

		if (existingRepositoryResponse != null && existingRepositoryResponse!.Id != 0)
		{
			return true;
		}
		return false;
	}

	public async Task<GitHubRepositoryResponse> CreateRepositoryIfNotExistsAsync(GitHubRepositoryRequest gitHubRepositoryToCreate)
	{
		if (!await RepositoryExists(gitHubRepositoryToCreate.Name))
		{
			var response = await _httpClient.PostAsJsonAsync("user/repos", gitHubRepositoryToCreate);

			response.EnsureSuccessStatusCode();

			var content = await response.Content.ReadAsStringAsync();

			var newlyCreatedGitHubRepository = _jsonSerialiser.Deserialize<GitHubRepositoryResponse>(content);

			ArgumentNullException.ThrowIfNull(newlyCreatedGitHubRepository);

			return newlyCreatedGitHubRepository;
		}
		else
		{
			var existingRepository = await GetGitHubRepository(gitHubRepositoryToCreate.Name, true);
			ArgumentNullException.ThrowIfNull(existingRepository);
			return existingRepository;
		}
	}

	public async Task<GitHubPublicKeyResponse> GetPublicKey(string repositoryName)
	{
		string endpoint = $"repos/{_gitHubOptions.Owner}/{repositoryName}/actions/secrets/public-key";

		HttpResponseMessage response = await _httpClient.GetAsync(endpoint);

		response.EnsureSuccessStatusCode();

		var jsonResponse = await response.Content.ReadAsStringAsync();
		var typedResponse = _jsonSerialiser.Deserialize<GitHubPublicKeyResponse>(jsonResponse);

		if (typedResponse != null)
		{
			return typedResponse;
		}

		throw new Exception("Deserialization of public-key response was null");
	}

	public async Task UpsertRepositorySecret(GitHubRepositorySecret gitHubRepositorySecret)
	{
		string secretEndpoint = $"repos/{_gitHubOptions.Owner}/{gitHubRepositorySecret.RepositoryName}/actions/secrets/{gitHubRepositorySecret.SecretName}";

		var publicKeyResponse = await GetPublicKey(gitHubRepositorySecret.RepositoryName);

		ArgumentNullException.ThrowIfNull(publicKeyResponse.KeyId);

		string jsonContent = JsonSerializer.Serialize(new RepositorySecretRequest(gitHubRepositorySecret.SecretValue, publicKeyResponse.KeyId));
		StringContent content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

		var secretResponse = await _httpClient.PutAsync(secretEndpoint, content);
		secretResponse.EnsureSuccessStatusCode();
	}
}
