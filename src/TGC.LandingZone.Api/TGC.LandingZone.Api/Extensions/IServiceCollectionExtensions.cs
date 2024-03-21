using TGC.LandingZone.Api.Integrations.Azure;
using TGC.LandingZone.Api.Services;
using TGC.LandingZone.Api.Services.Abstractions;

namespace TGC.LandingZone.Api.Extensions;

public static class IServiceCollectionExtensions
{
	public static IServiceCollection InjectServices(this IServiceCollection serviceDescriptors)
	{
		serviceDescriptors.AddScoped<IProjectService, ProjectService>();
		serviceDescriptors.AddScoped<IGraphService, GraphService>();
		serviceDescriptors.AddScoped<ISodiumEncryptionService, SodiumEncryptionService>();
		serviceDescriptors.AddScoped<IAzureService, AzureService>();

		return serviceDescriptors;
	}
}
