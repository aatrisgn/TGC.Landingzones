using Microsoft.Graph.Models;

namespace TGC.MSGraph;

public interface IGraphApplicationService
{
	Task<Application> CreateApplication(string name);
	Task<PasswordCredential> AddSecret(Guid applicationId);
	Task<UnifiedRoleAssignment> AddAsOwner(Guid applicationId, Guid resourceGroupId);
}
