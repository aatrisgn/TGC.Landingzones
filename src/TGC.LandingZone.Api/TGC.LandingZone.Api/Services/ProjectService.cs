using TGC.GitHub;
using TGC.GitHub.Models;
using TGC.LandingZone.Api.Integrations.Azure;
using TGC.LandingZone.Api.Models;
using TGC.LandingZone.Api.Services.Abstractions;

namespace TGC.LandingZone.Api.Services;

public class ProjectService : IProjectService
{
	private readonly IGitHubService _gitHubService;
	private readonly IAzureService _azureService;
	public ProjectService(IGitHubService gitHubService, IAzureService azureService)
	{
		_gitHubService = gitHubService;
		_azureService = azureService;
	}

	public async Task<Project> CreateOrUpdateProjectAsync(ProjectRequest project)
	{
		var gitHubRepositoryToCreate = new GitHubRepositoryRequest
		{
			Name = project.Name,
			Description = project.Description
		};

		List<ApplicationServiceConnection> projectServiceConnections = new List<ApplicationServiceConnection>();
		GitHubRepositoryResponse gitHubRepository = await _gitHubService.CreateRepositoryIfNotExistsAsync(gitHubRepositoryToCreate);

		var createdResouceGroup = await _azureService.CreateResourceGroupsIfNotExistsAsync(project);

		foreach (var resourceGroup in createdResouceGroup)
		{
			ApplicationServiceConnection applicationServiceConnection = await _azureService.CreateSPNIfNotExists(resourceGroup);
			projectServiceConnections.Add(applicationServiceConnection);

			await _azureService.AssignOwnerOnResourceGroupAsync(resourceGroup, applicationServiceConnection);
		}

		foreach (var serviceConnection in projectServiceConnections)
		{
			var secret = new GitHubRepositorySecret
			{
				RepositoryName = project.Name,
				SecretName = "ASdasd",
				SecretValue = serviceConnection.ToString()!
			};

			await _gitHubService.UpsertRepositorySecret(secret);
		}
		return new Project
		{
			Name = "asdasd",
			ApplicationEnvironments = new List<ApplicationEnvironments>(),
			ShortName = project.ShortName,
		};
	}

	public Task<IEnumerable<Project>> GetAllProjectsAsync()
	{
		throw new NotImplementedException();
	}

	public Task<Project> GetProjectByNameAsync(string name)
	{
		throw new NotImplementedException();
	}
}
