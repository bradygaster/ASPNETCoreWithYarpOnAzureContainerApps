using Microsoft.Extensions.Configuration;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();
builder.Services.AddHttpClient("catalog", (client) => client.BaseAddress = new Uri(builder.Configuration.GetValue<string>("CATALOG_API")));
builder.Services.AddHttpClient("orders", (client) => client.BaseAddress = new Uri(builder.Configuration.GetValue<string>("ORDERS_API")));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
}
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.Run();
