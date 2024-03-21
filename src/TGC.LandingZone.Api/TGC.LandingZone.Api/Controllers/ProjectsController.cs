using Microsoft.AspNetCore.Mvc;
using TGC.LandingZone.Api.Models;
using TGC.LandingZone.Api.Services.Abstractions;

namespace TGC.LandingZone.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProjectsController : ControllerBase
{
	private readonly IProjectService _projectService;
	public ProjectsController(IProjectService projectService)
	{
		_projectService = projectService;
	}

	[HttpGet]
	public async Task<IEnumerable<Project>> GetAllProjects()
	{
		return await _projectService.GetAllProjectsAsync();
	}

	[HttpGet("{name}")]
	public async Task<Project> GetProjectByName(string name)
	{
		return await _projectService.GetProjectByNameAsync(name);
	}

	[HttpPost]
	public async Task<Project> CreateNewProject([FromBody] ProjectRequest project)
	{
		return await _projectService.CreateOrUpdateProjectAsync(project);
	}
}
