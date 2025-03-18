using iStudyTest.Models;
using Microsoft.EntityFrameworkCore;
using iStudyTest.Filters;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<iStudyTestContext>(options =>
options.UseSqlServer(builder.Configuration.GetConnectionString("iStudyTestConnetion")));

//µù¥USession
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>{
    options.IdleTimeout = TimeSpan.FromMinutes(10);
});

// Add services to the container.
//builder.Services.AddControllersWithViews();
//µù¥Uµn¿ýª¬ºAFilter
builder.Services.AddScoped<LoginStatusFilter>();
builder.Services.AddScoped<EmpLoginStFilter>();

builder.Services.AddControllersWithViews(options =>
{
    options.Filters.Add<LogFilter>();
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
}
app.UseStaticFiles();

app.UseRouting();

app.UseSession();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
