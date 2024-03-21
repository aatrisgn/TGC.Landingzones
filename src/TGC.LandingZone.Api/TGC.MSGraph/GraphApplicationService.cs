using Microsoft.Graph.Applications.Item.AddPassword;
using Microsoft.Graph.Models;

namespace TGC.MSGraph;

internal class GraphApplicationService : IGraphApplicationService
{
	private readonly IGraphClientManager _graphClientManager;
	public GraphApplicationService(IGraphClientManager graphClientManager)
	{
		_graphClientManager = graphClientManager;
	}

	public async Task<Application> CreateApplication(string name)
	{
		var requestBody = new Application
		{
			DisplayName = name,
		};

		var client = _graphClientManager.GetClient();
		var result = await client.Applications.PostAsync(requestBody);

		ArgumentNullException.ThrowIfNull(result);

		return result;
	}

	public async Task<UnifiedRoleAssignment> AddAsOwner(Guid applicationId, Guid resourceGroupId)
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
	}

	public async Task<PasswordCredential> AddSecret(Guid applicationId)
	{
		var requestBody = new AddPasswordPostRequestBody
		{
			PasswordCredential = new PasswordCredential
			{
				DisplayName = "Password friendly name",
			},
		};

		var client = _graphClientManager.GetClient();
		var result = await client.Applications[applicationId.ToString()].AddPassword.PostAsync(requestBody);

		ArgumentNullException.ThrowIfNull(result);
		return result;
	}
}
