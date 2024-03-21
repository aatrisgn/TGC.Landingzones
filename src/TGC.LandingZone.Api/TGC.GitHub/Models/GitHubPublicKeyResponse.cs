using System.Text.Json.Serialization;

namespace TGC.GitHub.Models;

public class GitHubPublicKeyResponse
{
	[JsonPropertyName("key_id")]
	public string? KeyId { get; set; }
	[JsonPropertyName("key")]
	public string? Key { get; set; }
}
