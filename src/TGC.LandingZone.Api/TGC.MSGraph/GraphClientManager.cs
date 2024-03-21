using Azure.Identity;
using Microsoft.Extensions.Options;
using Microsoft.Graph;

namespace TGC.MSGraph;

internal sealed class GraphClientManager : IGraphClientManager
{
	private readonly GraphOptions _options;
	private GraphServiceClient? graphServiceClient;
	private object _lock = new();

	public GraphClientManager(IOptions<GraphOptions> options)
	{
		_options = options.Value;
	}

	public GraphServiceClient GetClient()
	{
		if (graphServiceClient == null)
		{
			lock (_lock)
			{
				if (graphServiceClient != null)
				{
					return graphServiceClient;
				}

				var options = new ClientSecretCredentialOptions
				{
					AuthorityHost = AzureAuthorityHosts.AzurePublicCloud,
				};

				var clientSecretCredential = new ClientSecretCredential(_options.TenantId, _options.ClientId, _options.ClientSecret, options);

				graphServiceClient = new GraphServiceClient(clientSecretCredential, _options.Scopes);
			}
		}
		return graphServiceClient;
	}
}
