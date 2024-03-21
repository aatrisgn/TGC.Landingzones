using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using TGC.Common.Exceptions.Extensions;

namespace TGC.GitHub.Extensions;
public static class WebApplicationBuilderExtensions
{
	/// <summary>
	/// Injects and configures relevant implementations for using TGC.GitHub for managing GitHub credentials.
	/// </summary>
	/// <param name="builder">WebApplicationBuilder for service collection where injections are made.</param>
	/// <returns>WebApplicationBuilder with populated service collection</returns>
	public static WebApplicationBuilder ConfigureGitHubClient(this WebApplicationBuilder builder)
	{
		builder.Services.AddCoreSerialization();
		builder.Services.AddHttpClient<IGitHubService, GitHubService>(client =>
		{
			var baseUrl = builder.Configuration["Integrations:GitHub:Url"];
			var patToken = builder.Configuration["Integrations:GitHub:PAT"];
			var userAgent = builder.Configuration["Integrations:GitHub:UserAgent"];

			if (baseUrl != null && patToken != null)
			{
				client.BaseAddress = new Uri(baseUrl);
				client.DefaultRequestHeaders.Add("Authorization", $"Bearer {patToken}");
				client.DefaultRequestHeaders.Add("accept", $"application/vnd.github+json");
				client.DefaultRequestHeaders.Add("User-Agent", userAgent);
			}
		});

		builder.Services.Configure<GitHubOptions>(builder.Configuration.GetSection(GitHubOptions.SectionName));

		return builder;
	}
}
