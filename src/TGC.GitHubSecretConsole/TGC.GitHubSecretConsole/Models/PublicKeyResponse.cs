using System.Text.Json.Serialization;

namespace TGC.GitHubSecretConsole.Models
{
	public class PublicKeyResponse
	{
		[JsonPropertyName("key_id")]
		public string? KeyId { get; set; }
		[JsonPropertyName("key")]
		public string? Key { get; set; }
	}
}
