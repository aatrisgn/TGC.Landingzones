using System.Text.Json.Serialization;

namespace TGC.GitHub.Models;

public class GitHubRepositoryRequest
{
	[JsonPropertyName("name")]
	public required string Name { get; set; }
	[JsonPropertyName("description")]
	public string? Description { get; set; }
	[JsonPropertyName("private")]
	public bool Private { get; set; }

	public GitHubRepositoryRequest()
	{
		Private = false;
	}
}
