namespace TGC.Azure;

public class AzureCredentialOptions
{
	public const string SectionName = "Integrations:Azure";
	public Guid SubscriptionId { get; set; }
	public Guid ManagedIdentity { get; set; }
	public string? PrincipalName { get; set; }
	public string? PrincipalPassword { get; set; }

	public bool ManagedIdentityIsConfigured()
	{
		return string.IsNullOrEmpty(ManagedIdentity.ToString());
	}
}
