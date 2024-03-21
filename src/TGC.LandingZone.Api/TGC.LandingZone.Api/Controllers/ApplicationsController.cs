using Microsoft.AspNetCore.Mvc;
using TGC.LandingZone.Api.Models;
using TGC.LandingZone.Api.Services;

namespace TGC.LandingZone.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ApplicationsController : ControllerBase
{
	private readonly IGraphService _graphService;
	public ApplicationsController(IGraphService graphService)
	{
		_graphService = graphService;
	}

	[HttpPost]
	public async Task<ApplicationResponse> CreateApplication([FromBody] ApplicationRequest applicationRequest)
	{
		return await _graphService.CreateApplication(applicationRequest);
	}

	[HttpPut("{applicationId}/associate/{resourcegroupId}")]
	public async Task<ApplicationAssociationResponse> AssociateSPN(Guid applicationId, Guid resourcegroupId)
	{
		return await _graphService.AssociateSPN(applicationId, resourcegroupId);
	}
}
