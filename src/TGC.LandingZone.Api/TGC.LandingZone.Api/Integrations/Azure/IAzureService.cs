using Azure.ResourceManager.Resources;
using TGC.LandingZone.Api.Models;

namespace TGC.LandingZone.Api.Integrations.Azure;

public interface IAzureService
{
	Task AssignOwnerOnResourceGroupAsync(ResourceGroupData resourceGroupData, ApplicationServiceConnection applicationServiceConnection);
	Task<IEnumerable<ResourceGroupData>> CreateResourceGroupsIfNotExistsAsync(ProjectRequest project);
	Task<ApplicationServiceConnection> CreateSPNIfNotExists(ResourceGroupData applicationEnvironment);
}
