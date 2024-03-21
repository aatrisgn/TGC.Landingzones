namespace TGC.GitHub.Models;

public class GitHubRepositorySecret
{
	public required string SecretName { get; set; }
	public required string SecretValue { get; set; }
	public required string RepositoryName { get; set; }
}
