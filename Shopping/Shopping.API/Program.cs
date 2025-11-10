using System.Data.Common;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Shopping.Domain.Repositories;
using Shopping.Domain.Services;
using Microsoft.OpenApi.Models;

var MyAllowSpecificOrigins = "_myAllowSpecificOrigins";

var builder = WebApplication.CreateBuilder(args);
var config = builder.Configuration;

// --- SERVICE CORS ---
builder.Services.AddCors(options =>
{
    options.AddPolicy(name: MyAllowSpecificOrigins,
                      policy =>
                      {
                          policy.WithOrigins(
                                "http://localhost:4200",  // Angular
                                "http://localhost:5159")  // Swagger/API
                                .AllowAnyHeader()
                                .AllowAnyMethod();
                      });
});

// --- SERVICES DB & CQS ---
builder.Services.AddScoped<DbConnection>(sp =>
{
    var connectionString = config.GetConnectionString("DefaultConnection");
    return new SqlConnection(connectionString);
});

// Enregistrement de tous vos services/repositories
builder.Services.AddScoped<IUserRepository, UserService>();
builder.Services.AddScoped<ITokenService, TokenService>();
builder.Services.AddScoped<IShoppingListRepository, ShoppingListService>();
builder.Services.AddScoped<IUnitRepository, UnitService>();

// --- LE VALIDATEUR JWT (Version Finale) ---
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,

            // Lit les valeurs de appsettings.json
            ValidIssuer = config["Jwt:Issuer"],
            ValidAudience = config["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(config["Jwt:Key"]))
        };
    });

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Description = "Entrez 'Bearer' [espace] puis votre jeton (token)",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.Http,
        Scheme = "Bearer",
        BearerFormat = "JWT"
    });
    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" }
            },
            new string[] {}
        }
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// app.UseHttpsRedirection(); // Laissé commenté

// --- PIPELINE (L'ordre est crucial) ---
app.UseCors(MyAllowSpecificOrigins); // 1. CORS
app.UseAuthentication(); // 2. Authentification
app.UseAuthorization(); // 3. Autorisation

app.MapControllers();
app.Run();