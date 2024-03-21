using TGC.LandingZone.Api.Models;

namespace TGC.LandingZone.Api.Services;

public interface IGraphService
{
	Task<ApplicationAssociationResponse> AssociateSPN(Guid applicationId, Guid resourcegroupId);
	Task<ApplicationResponse> CreateApplication(ApplicationRequest applicationRequest);
}
