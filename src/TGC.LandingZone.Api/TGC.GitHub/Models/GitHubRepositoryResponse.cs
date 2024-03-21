using System.Text.Json.Serialization;

namespace TGC.GitHub.Models;

public class GitHubRepositoryResponse
{
	[JsonPropertyName("id")]
	public int Id { get; set; }
	[JsonPropertyName("name")]
	public string? Name { get; set; }
	[JsonPropertyName("description")]
	public string? Description { get; set; }
	[JsonPropertyName("private")]
	public bool Private { get; set; }
}
