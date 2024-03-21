using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;

namespace TGC.Azure.Extensions;
public static class WebApplicationBuilderExtensions
{
	/// <summary>
	/// Injects and configures relevant implementations for using TGC.Azure for providing Azure credentials.
	/// </summary>
	/// <param name="builder">WebApplicationBuilder for service collection where injections are made.</param>
	/// <returns>WebApplicationBuilder with populated service collection</returns>
	public static WebApplicationBuilder ConfigureAzureCredentialProvider(this WebApplicationBuilder builder)
	{
		builder.Services.Configure<AzureCredentialOptions>(builder.Configuration.GetSection(AzureCredentialOptions.SectionName));

		builder.Services.AddSingleton<IAzureCredentialFactory, AzureCredentialFactory>();

		return builder;
	}
}
