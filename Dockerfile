FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["HelloAspnetCore.csproj", "./"]
RUN dotnet restore "./HelloAspnetCore.csproj"
COPY . .
RUN dotnet build "HelloAspnetCore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HelloAspnetCore.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloAspnetCore.dll"]
