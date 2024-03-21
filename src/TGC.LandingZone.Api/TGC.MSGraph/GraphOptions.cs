namespace TGC.MSGraph;

public sealed class GraphOptions
{
	public const string SectionName = "TGC:Integrations:Graph";
	public string? TenantId { get; set; }
	public string? ClientId { get; set; }
	public IEnumerable<string> Scopes { get; set; } = Enumerable.Empty<string>();
	public string? ClientSecret { get; set; }
}
