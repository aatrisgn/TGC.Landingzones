using CommandLine;

namespace TGC.GitHubSecretConsole
{
	public class CommandlineOptions
	{
		[Option('o', "owner", Required = true, HelpText = "Owner of the repository for which to create a new repository secret.")]
		public required string Owner { get; set; }
		[Option('r', "repository", Required = true, HelpText = "Name of the repository for which to create a new repository secret.")]
		public required string Repository { get; set; }
		[Option('s', "secretname", Required = true, HelpText = "Name of the new repository secret to create.")]
		public required string SecretName { get; set; }
		[Option('t', "pat", Required = true, HelpText = "Personal access token (PAT) with the correct access rights for repository and secrets.")]
		public required string PersonalAccessToken { get; set; }
		[Option('p', "payload", Required = true, HelpText = "Content which should be added a GitHub repository secret.")]
		public required string SecretPayload { get; set; }
	}
}
