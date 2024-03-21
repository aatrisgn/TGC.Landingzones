using Microsoft.Graph.Models;

namespace TGC.LandingZone.Api.Models;

public class ApplicationResponse
{
	public required Guid Id { get; set; }
	public required string DisplayName { get; set; }

	public static ApplicationResponse FromApplication(Application application)
	{
		ArgumentNullException.ThrowIfNull(application.Id);
		ArgumentNullException.ThrowIfNull(application.DisplayName);

		return new ApplicationResponse
		{
			DisplayName = application.DisplayName,
			Id = Guid.Parse(application.Id)
		};
	}
}
