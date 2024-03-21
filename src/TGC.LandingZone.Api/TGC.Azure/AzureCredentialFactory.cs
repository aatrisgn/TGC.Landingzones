using Azure.Core;
using Azure.Identity;
using Azure.ResourceManager;
using Azure.ResourceManager.Resources;
using Microsoft.Extensions.Options;

namespace TGC.Azure;
internal sealed class AzureCredentialFactory : IAzureCredentialFactory
{
	private DefaultAzureCredential? defaultAzureCredential { get; set; }
	private ArmClient? ArmClient { get; set; }

	private readonly AzureCredentialOptions _azureCredentialOptions;

	private readonly object _lock = new();

	public AzureCredentialFactory(IOptions<AzureCredentialOptions> azureCredentialOptions)
	{
		_azureCredentialOptions = azureCredentialOptions.Value;
	}

	public async Task<string> GetClientAccessToken()
	{
		var context = new TokenRequestContext(new[] { "https://management.azure.com/.default" });
		var token = await GetCredentials().GetTokenAsync(context);
		return token.Token;
	}

	public ArmClient GetClient()
	{
		if (ArmClient != null)
		{
			return this.ArmClient;
		}

		lock (_lock)
		{
			if (ArmClient != null)
			{
				return ArmClient;
			}

			ArmClient = new ArmClient(GetCredentials());
		}

		return ArmClient;
	}

	public async Task<SubscriptionResource> GetDefaultSubscription()
	{
		var armClient = GetClient();
		return await armClient.GetDefaultSubscriptionAsync();
	}

	private DefaultAzureCredential GetCredentials()
	{
		if (defaultAzureCredential != null)
		{
			return this.defaultAzureCredential;
		}

		lock (_lock)
		{
			if (defaultAzureCredential != null)
			{
				return defaultAzureCredential;
			}

			if (_azureCredentialOptions.ManagedIdentityIsConfigured())
			{
				defaultAzureCredential = new DefaultAzureCredential(new DefaultAzureCredentialOptions { ManagedIdentityClientId = _azureCredentialOptions.ManagedIdentity.ToString() });
			}
			else
			{
				defaultAzureCredential = new DefaultAzureCredential();
			}
		}

		return defaultAzureCredential;
	}
}
