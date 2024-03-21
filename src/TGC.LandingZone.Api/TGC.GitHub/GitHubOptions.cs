namespace TGC.GitHub;

public class GitHubOptions
{
	public const string SectionName = "Integrations:GitHub";
	public string? PAT { get; set; }
	public string? Url { get; set; }
	public string? Owner { get; set; }
	public string? UserAgent { get; set; }
}
