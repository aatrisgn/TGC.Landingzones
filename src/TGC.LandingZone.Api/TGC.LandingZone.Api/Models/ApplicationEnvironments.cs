namespace TGC.LandingZone.Api.Models;

public class ApplicationEnvironments
{
	public required EnvironmentType Type { get; set; }
	public required IEnumerable<DeploymentZone> DeploymentZones { get; set; }
}
