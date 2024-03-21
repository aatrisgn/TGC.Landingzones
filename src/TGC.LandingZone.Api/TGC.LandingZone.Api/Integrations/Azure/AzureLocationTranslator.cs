using Azure.Core;
using TGC.LandingZone.Api.Models;

namespace TGC.LandingZone.Api.Integrations.Azure;

public static class DeploymentZoneLocationExtensions
{
	public static AzureLocation TranslateLocationToAzure(this DeploymentZoneLocation deploymentZoneLocation)
	{
		switch (deploymentZoneLocation)
		{
			case DeploymentZoneLocation.WestEurope:
				return AzureLocation.WestEurope;
			case DeploymentZoneLocation.NorthEurope:
				return AzureLocation.NorthEurope;
			default:
				throw new NotImplementedException($"Location {deploymentZoneLocation.ToString()} is not supported yet.");
		}
	}
}
