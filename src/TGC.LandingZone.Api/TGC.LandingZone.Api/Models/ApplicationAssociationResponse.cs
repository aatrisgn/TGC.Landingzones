namespace TGC.LandingZone.Api.Models;

public class ApplicationAssociationResponse
{
	public required Guid ResourceGroupId { get; set; }
	public required Guid ApplicationId { get; set; }
}
