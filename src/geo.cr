require "redis"

module Redis::Commands::Geo
  def geohash(key : String, *members : String)
    run({"geohash", key, *members})
  end
end

redis = Redis::Client.new

# Adds geospatial items (longitude, latitude, name) to the specified key.
redis.geoadd("buses", "-74.0002041", "40.7178486", "Bus A")
redis.geoadd("buses", "-73.9947324", "40.7258577", "Bus B")

# Returns all entries in an index
p! redis.zrange("buses", 0, -1)

# Returns the coordinates of the entry in the index:
p! redis.geopos("buses", "Bus A")
p! redis.geopos("buses", "Bus B")

# Returns the coordinates of the entry encoded in the geohash
p! redis.geohash("buses", "Bus A")
p! redis.geohash("buses", "Bus B")

# Get the distance between two entries in an index.
#
# You can specify the required units of measurement by passing the fourth argument to the command,
# for example:
# - `:km` for kilometers
# - `:m` for meters
# - `:mi` for miles
# - `:ft` for feet
p! redis.geodist("buses", "Bus A", "Bus B", :m)

p! redis.geosearch("buses", frommember: "Bus A", byradius: Redis::Geo::Radius.new(1000, :m))
p! redis.geosearch("buses", fromlonlat: {"-74.0002041", "40.7178486"}, byradius: Redis::Geo::Radius.new(2, :km))

# Also search accept the parameters WITHDIST (display results + distance from the specified point/record)
# and WITHCOORD (display results + record coordinates),
# as well as the ASC or DESC sort option (sort by distance from the point):
p! redis.geosearch("buses", fromlonlat: {"-74.0002041", "40.7178486"}, byradius: Redis::Geo::Radius.new(2, :km), withdist: true)
p! redis.geosearch("buses", fromlonlat: {"-74.0002041", "40.7178486"}, byradius: Redis::Geo::Radius.new(2000, :m), withdist: true, sort: :asc)

redis.zrem("buses", "Bus A")
redis.zrem("buses", "Bus B")
redis.del("buses")
