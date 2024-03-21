using Azure;
using Azure.Core;
using Azure.ResourceManager.Resources;
using TGC.Azure;
using TGC.LandingZone.Api.Models;

namespace TGC.LandingZone.Api.Integrations.Azure;
public class AzureService : IAzureService
{
	private readonly IAzureCredentialFactory _azureCredentialFactory;
	private readonly HttpClient _httpClient;

	public AzureService(IAzureCredentialFactory azureCredentialFactory, HttpClient httpClient)
	{
		_azureCredentialFactory = azureCredentialFactory;
		_httpClient = httpClient;
	}

	public async Task AssignOwnerOnResourceGroupAsync(ResourceGroupData resourceGroupData, ApplicationServiceConnection applicationServiceConnection)
	{
		// PUT https://management.azure.com/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentId}?api-version=2022-04-01

		/*
		 * {
			  "properties": {
				"roleDefinitionId": "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
				"principalId": "{principalId}"
			  }
			}
		 * 
		 * 
		 */

		var resourceGroupScope = resourceGroupData.Id;

		var roleAssiginmentScope = $"{resourceGroupScope}/8e3af657-a8ff-443c-a75c-2fe8c4bcb635";
		var roleAssignmentUrl = new Uri($"{resourceGroupScope}/8e3af657-a8ff-443c-a75c-2fe8c4bcb635?api-version=2022-04-01");

		await _httpClient.PutAsJsonAsync(roleAssignmentUrl, new Dictionary<string, RBACAssignment> { { "properties", new RBACAssignment(roleAssiginmentScope, applicationServiceConnection.PrincipalId) } });
	}

	public async Task<IEnumerable<ResourceGroupData>> CreateResourceGroupsIfNotExistsAsync(ProjectRequest project)
	{
		var subscription = await _azureCredentialFactory.GetDefaultSubscription();
		var existingResourceGroups = subscription.GetResourceGroups();
		var resourceGroupData = new List<ResourceGroupData>();

		foreach (var environment in project.ApplicationEnvironments)
		{
			var resourceGroupNames = environment.DeploymentZones.Select(x => $"rg-{environment.Type.ToString()}-{x.Name.ToLower()}-{x.Location.TranslateLocationToAzure().ToString()}").ToList();

			foreach (var resourceGroupName in resourceGroupNames)
			{
				var resourceGroupAssertion = new ResourceGroupData(AzureLocation.WestEurope);
				resourceGroupAssertion.Tags.Add("PROJECT", project.Name);
				resourceGroupAssertion.Tags.Add("ENV", environment.Type.ToString());
				resourceGroupAssertion.Tags.Add("MANAGEDBY", "LandingZoneAPI");

				var updatedResourceGroup = await existingResourceGroups.CreateOrUpdateAsync(WaitUntil.Started, resourceGroupName, resourceGroupAssertion);
				resourceGroupData.Add(updatedResourceGroup.Value.Data);
			}
		}

		return resourceGroupData;
	}

	public Task<ApplicationServiceConnection> CreateSPNIfNotExists(ResourceGroupData applicationEnvironment)
	{
		throw new NotImplementedException();
		// https://learn.microsoft.com/en-us/graph/api/application-post-applications?view=graph-rest-1.0&tabs=http
	}
}
