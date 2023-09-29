using NSec.Cryptography;
using System.Text;
using System.Text.Json;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace TGC.SodiumEncryptor;

internal class Program
{
	static async Task Main(string[] args)
	{
		string owner = "aatrisgn";
		string repo = "SomeRepository"; //args[0];
		//string personalAccessToken = args[1];

		Console.WriteLine("PAT");
		string personalAccessToken = Console.ReadLine();

		var algorithm = SignatureAlgorithm.Ed25519;

		using (HttpClient httpClient = new HttpClient())
		{
			httpClient.BaseAddress = new Uri("https://api.github.com/");

			httpClient.DefaultRequestHeaders.Add("Authorization", $"Bearer {personalAccessToken}");
			httpClient.DefaultRequestHeaders.Add("X-GitHub-Api-Version", "2022-11-28");
			httpClient.DefaultRequestHeaders.Add("Accept", "application/vnd.github+json");
			httpClient.DefaultRequestHeaders.Add("User-Agent", "MyGitHubApiClient");

			try
			{
				string endpoint = $"repos/{owner}/{repo}/actions/secrets/public-key";

				HttpResponseMessage response = await httpClient.GetAsync(endpoint);

				if (response.IsSuccessStatusCode)
				{
					var jsonResponse = await response.Content.ReadAsStringAsync();
					var typedResponse = JsonSerializer.Deserialize<publicKeyResponse>(jsonResponse);

					var data = Encoding.UTF8.GetBytes("Use the Force, Luke!");

					var data2 = Encoding.UTF8.GetBytes(typedResponse.key);

					var key = Key.TryImport(algorithm, data2, KeyBlobFormat.NSecPublicKey, out Key asome);
					//var key2 = Key.Import(algorithm, data2);

					var signature = algorithm.Sign(asome, data);

					//var signature = algorithm.Sign(typedResponse.key, data);
				}
				else
				{
					string jsonResponse = await response.Content.ReadAsStringAsync();
					Console.WriteLine($"Error: {response.StatusCode} - {response.ReasonPhrase}");
				}
			}
			catch (HttpRequestException ex)
			{
				Console.WriteLine($"HTTP request error: {ex.Message}");
			}
		}
	}

	public class publicKeyResponse
	{
		public string key_id { get; set; }
		public string key { get; set; }
	}
}