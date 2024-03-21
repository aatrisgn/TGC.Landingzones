using Azure.ResourceManager;
using Azure.ResourceManager.Resources;

namespace TGC.Azure;
public interface IAzureCredentialFactory
{
	ArmClient GetClient();
	Task<string> GetClientAccessToken();
	Task<SubscriptionResource> GetDefaultSubscription();
}
