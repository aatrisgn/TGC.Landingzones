using TGC.Azure.Extensions;
using TGC.LandingZone.Api.Extensions;
using TGC.GitHub.Extensions;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.ConfigureAzureCredentialProvider();
builder.Services.InjectServices();
builder.ConfigureHttpClients();
builder.ConfigureGraphClient();
builder.ConfigureGitHubClient();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
	app.UseSwagger();
	app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
