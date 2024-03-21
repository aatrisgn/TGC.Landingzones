namespace TGC.LandingZone.Api.Services.Abstractions;

public interface ISodiumEncryptionService
{
	string EncryptMessage(string message, string key);
}
