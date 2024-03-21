using TGC.GitHub.Models;

namespace TGC.GitHub;

public interface IGitHubService
{
	Task<GitHubRepositoryResponse> CreateRepositoryIfNotExistsAsync(GitHubRepositoryRequest gitHubRepositoryToCreate);
	Task<GitHubPublicKeyResponse> GetPublicKey(string repositoryName);
	Task UpsertRepositorySecret(GitHubRepositorySecret gitHubRepositorySecret);
}
