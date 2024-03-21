namespace TGC.LandingZone.Api.Integrations.Azure;

public class AzureResourceGroup
{
	public string Name { get; set; }
	public string Id { get; set; }

	public AzureResourceGroup(string name, string id)
	{
		Id = id;
		Name = name;
	}
}
