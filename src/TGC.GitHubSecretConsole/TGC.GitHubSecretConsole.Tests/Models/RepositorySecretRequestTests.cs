using FluentAssertions;
using TGC.GitHubSecretConsole.Models;

namespace TGC.GitHubSecretConsole.Tests.Models
{
    internal class RepositorySecretRequestTests
    {
        [Test]
        public void GIVEN_NewlyInstantiatedRepositorySecretRequest_THEN_PropertiesAreCorrectlySet()
        {
            var encryptionValue = "SomeEncryptedValue";
            var encryptionKeyId = "someEncryptionKey";


			var repositorySecretRequest = new RepositorySecretRequest(encryptionValue, encryptionKeyId);

            repositorySecretRequest.Should().NotBeNull();

			repositorySecretRequest.KeyId.Should().Be(encryptionKeyId);
			repositorySecretRequest.EncryptedValue.Should().Be(encryptionValue);
		}
    }
}
