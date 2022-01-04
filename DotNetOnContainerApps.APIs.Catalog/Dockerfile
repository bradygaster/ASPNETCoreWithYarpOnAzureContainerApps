#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DotNetOnContainerApps.APIs.Catalog/DotNetOnContainerApps.APIs.Catalog.csproj", "DotNetOnContainerApps.APIs.Catalog/"]
RUN dotnet restore "DotNetOnContainerApps.APIs.Catalog/DotNetOnContainerApps.APIs.Catalog.csproj"
COPY . .
WORKDIR "/src/DotNetOnContainerApps.APIs.Catalog"
RUN dotnet build "DotNetOnContainerApps.APIs.Catalog.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNetOnContainerApps.APIs.Catalog.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetOnContainerApps.APIs.Catalog.dll"]