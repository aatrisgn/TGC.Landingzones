using TGC.LandingZone.Api.Integrations.Azure;

namespace TGC.LandingZone.Api.Extensions;

public static class WebApplicationBuilderExtensions
{
	public static WebApplicationBuilder ConfigureHttpClients(this WebApplicationBuilder builder)
	{
		builder.Services.AddHttpClient<IAzureService, AzureService>(client =>
		{
			var baseUrl = builder.Configuration["Integrations:Azure:ManagementUrl"];
			if (baseUrl != null)
			{
				client.BaseAddress = new Uri(baseUrl);
			}
		});

		return builder;
	}
}
