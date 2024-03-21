using System.Text;
using TGC.LandingZone.Api.Services.Abstractions;

namespace TGC.LandingZone.Api.Services;
public class SodiumEncryptionService : ISodiumEncryptionService
{
	public string EncryptMessage(string message, string key)
	{
		var secretValue = Encoding.UTF8.GetBytes(message);
		var publicKey = Convert.FromBase64String(key);

		var sealedPublicKeyBox = Sodium.SealedPublicKeyBox.Create(secretValue, publicKey);

		return Convert.ToBase64String(sealedPublicKeyBox);
	}
}
