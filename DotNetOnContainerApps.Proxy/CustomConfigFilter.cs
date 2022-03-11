using System.Text.RegularExpressions;
using Yarp.ReverseProxy.Configuration;

namespace DotNetOnContainerApps.Proxy
{
    public class CustomConfigFilter : IProxyConfigFilter
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger<CustomConfigFilter> _logger;

        public CustomConfigFilter(IConfiguration configuration, ILogger<CustomConfigFilter> logger)
        {
            this._configuration = configuration;
            this._logger = logger;
        }

        // Matches {{env_var_name}} or {{my-name}} or {{123name}} etc.
        private readonly Regex _exp = new("\\{\\{(\\w+\\-?\\w+?)\\}\\}");

        public ValueTask<ClusterConfig> ConfigureClusterAsync(ClusterConfig cluster, CancellationToken cancel)
        {
            // Each cluster has a dictionary of destinations, which is read-only, so we'll create a new one with our updates 
            var destinations = new Dictionary<string, DestinationConfig>(StringComparer.OrdinalIgnoreCase);

            if (cluster.Destinations != null)
            {
                foreach (var d in cluster.Destinations)
                {
                    var origAddress = d.Value.Address;
                    if (_exp.IsMatch(origAddress))
                    {
                        // Get the name of the env variable from the destination and lookup value
                        var lookup = _exp.Matches(origAddress)[0].Groups[1].Value;
                        var newAddress = _configuration.GetValue<string>(lookup);

                        if (string.IsNullOrWhiteSpace(newAddress))
                        {
                            throw new System.ArgumentException(
                                $"Configuration Filter Error: Substitution for '{lookup}' in cluster '{d.Key}' not found in configuration.");
                        }

                        var modifiedDest = d.Value with {Address = newAddress};
                        destinations.Add(d.Key, modifiedDest);
                    }
                    else
                    {
                        destinations.Add(d.Key, d.Value);
                    }
                }
            }
            else
            {
                this._logger.LogInformation("cluster.Destinations is null");
            }

            return new ValueTask<ClusterConfig>(cluster with { Destinations = destinations });
        }

        public ValueTask<RouteConfig> ConfigureRouteAsync(RouteConfig route, ClusterConfig? cluster, CancellationToken cancel)
        {
            if (route.Order is < 1)
            {
                return new ValueTask<RouteConfig>(route with { Order = 1 });
            }

            return new ValueTask<RouteConfig>(route);
        }
    }
}
