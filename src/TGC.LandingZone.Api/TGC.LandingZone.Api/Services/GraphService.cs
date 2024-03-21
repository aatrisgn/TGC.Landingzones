using TGC.LandingZone.Api.Models;
using TGC.MSGraph;

namespace TGC.LandingZone.Api.Services;

public class GraphService : IGraphService
{
	private readonly IGraphApplicationService _applicationService;
	public GraphService(IGraphApplicationService applicationService)
	{
		_applicationService = applicationService;
	}

	public async Task<ApplicationAssociationResponse> AssociateSPN(Guid applicationId, Guid resourcegroupId)
	{
		var secret = await _applicationService.AddSecret(applicationId);
		var some = await _applicationService.AddAsOwner(applicationId, resourcegroupId);

		return new ApplicationAssociationResponse { ApplicationId = applicationId, ResourceGroupId = resourcegroupId};
	}

	public async Task<ApplicationResponse> CreateApplication(ApplicationRequest applicationRequest)
	{
		var application = await _applicationService.CreateApplication(applicationRequest.DisplayName);
		return ApplicationResponse.FromApplication(application);
	}
}
