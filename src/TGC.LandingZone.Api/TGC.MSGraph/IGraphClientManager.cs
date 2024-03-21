using Microsoft.Graph;

namespace TGC.MSGraph;

public interface IGraphClientManager
{
	GraphServiceClient GetClient();
}
