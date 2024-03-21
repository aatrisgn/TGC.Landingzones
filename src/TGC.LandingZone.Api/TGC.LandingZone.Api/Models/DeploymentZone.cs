namespace TGC.LandingZone.Api.Models;

public class DeploymentZone
{
	public required string Name { get; set; }
	public required DeploymentZoneLocation Location { get; set; }
}
