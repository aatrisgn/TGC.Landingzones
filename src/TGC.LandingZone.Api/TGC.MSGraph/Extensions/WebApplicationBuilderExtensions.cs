using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using TGC.MSGraph;

namespace TGC.Azure.Extensions;
public static class WebApplicationBuilderExtensions
{
	/// <summary>
	/// Injects and configures relevant implementations for using TGC.Azure for providing Azure credentials.
	/// </summary>
	/// <param name="builder">WebApplicationBuilder for service collection where injections are made.</param>
	/// <returns>WebApplicationBuilder with populated service collection</returns>
	public static WebApplicationBuilder ConfigureGraphClient(this WebApplicationBuilder builder)
	{
		builder.Services.Configure<GraphOptions>(builder.Configuration.GetSection(GraphOptions.SectionName));

		builder.Services.AddSingleton<IGraphClientManager, GraphClientManager>();
		builder.Services.AddTransient<IGraphApplicationService, GraphApplicationService>();

		return builder;
	}
}
