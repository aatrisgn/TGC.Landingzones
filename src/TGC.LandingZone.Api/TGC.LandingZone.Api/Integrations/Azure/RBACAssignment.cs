using System.Text.Json.Serialization;

namespace TGC.LandingZone.Api.Integrations.Azure;

public class RBACAssignment
{
	[JsonPropertyName("roleDefinitionId")]
	public string RoleDefinitionId { get; set; }
	[JsonPropertyName("principalId")]
	public Guid PrincipalId { get; set; }

	public RBACAssignment(string roleDefinitionId, Guid principalId)
	{
		RoleDefinitionId = roleDefinitionId;
		PrincipalId = principalId;
	}
}
