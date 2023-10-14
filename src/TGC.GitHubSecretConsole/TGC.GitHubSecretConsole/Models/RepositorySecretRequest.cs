using System.Text.Json.Serialization;

namespace TGC.GitHubSecretConsole.Models
{
	public class RepositorySecretRequest
	{
		public RepositorySecretRequest(string encryptedValue, string keyId)
		{
			KeyId = keyId;
			EncryptedValue = encryptedValue;
		}

		[JsonPropertyName("encrypted_value")]
		public string EncryptedValue { get; init; }
		[JsonPropertyName("key_id")]
		public string KeyId { get; init; }
	}
}
