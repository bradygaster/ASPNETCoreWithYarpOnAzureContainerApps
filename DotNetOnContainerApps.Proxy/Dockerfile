#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DotNetOnContainerApps.Proxy/DotNetOnContainerApps.Proxy.csproj", "DotNetOnContainerApps.Proxy/"]
RUN dotnet restore "DotNetOnContainerApps.Proxy/DotNetOnContainerApps.Proxy.csproj"
COPY . .
WORKDIR "/src/DotNetOnContainerApps.Proxy"
RUN dotnet build "DotNetOnContainerApps.Proxy.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNetOnContainerApps.Proxy.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetOnContainerApps.Proxy.dll"]