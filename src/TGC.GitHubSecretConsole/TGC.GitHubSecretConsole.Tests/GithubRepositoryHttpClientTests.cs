using FluentAssertions;

namespace TGC.GitHubSecretConsole.Tests
{
	internal class GithubRepositoryHttpClientTests
	{
		[Test]
		public void GIVEN_NewlyInstantiatedGithubRepositoryClient_THEN_DefaultHeadersAreSet()
		{
			var pat = "SomeToken";
			var owner = "SomeOwner";
			var repository = "SomeRepository";

			var githubHttpClient = new GithubRepositoryHttpClient(pat, owner, repository);

			githubHttpClient.Should().NotBeNull();

			var authHeader = githubHttpClient.DefaultRequestHeaders.Single(header => header.Key == "Authorization");
			authHeader.Value.Count().Should().Be(1);
			authHeader.Value.First().Should().Be($"Bearer {pat}");


			var githubApiHeader = githubHttpClient.DefaultRequestHeaders.Single(header => header.Key == "X-GitHub-Api-Version");
			githubApiHeader.Value.Count().Should().Be(1);
			githubApiHeader.Value.First().Should().Be("2022-11-28");

			var acceptHeader = githubHttpClient.DefaultRequestHeaders.Single(header => header.Key == "Accept");
			acceptHeader.Value.Count().Should().Be(1);
			acceptHeader.Value.First().Should().Be("application/vnd.github+json");

			var userAgent = githubHttpClient.DefaultRequestHeaders.Single(header => header.Key == "User-Agent");
			userAgent.Value.Count().Should().Be(1);
			userAgent.Value.First().Should().Be("MyGitHubApiClient");
		}

		[Test]
		public void GIVEN_NewlyInstantiatedGithubRepositoryClient_THEN_BaseAddressIsSet()
		{
			var pat = "SomeToken";
			var owner = "SomeOwner";
			var repository = "SomeRepository";

			var githubHttpClient = new GithubRepositoryHttpClient(pat, owner, repository);

			githubHttpClient.Should().NotBeNull();
			githubHttpClient.BaseAddress.Should().NotBeNull();
			githubHttpClient.BaseAddress.AbsoluteUri.Should().Be("https://api.github.com/");
		}
	}
}
