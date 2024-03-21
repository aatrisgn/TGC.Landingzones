namespace TGC.LandingZone.Api.Models;

public class Project
{
	public required string Name { get; set; }
	public required string ShortName { get; set; }
	public string? Description { get; set; }
	public required IEnumerable<ApplicationEnvironments> ApplicationEnvironments { get; set; }
}
