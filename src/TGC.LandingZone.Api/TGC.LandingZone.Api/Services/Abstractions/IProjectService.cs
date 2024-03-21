using TGC.LandingZone.Api.Models;

namespace TGC.LandingZone.Api.Services.Abstractions;

public interface IProjectService
{
	Task<Project> CreateOrUpdateProjectAsync(ProjectRequest project);
	Task<IEnumerable<Project>> GetAllProjectsAsync();
	Task<Project> GetProjectByNameAsync(string name);
}
