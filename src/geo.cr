require "redis"

redis = Redis.new

# Adds geospatial items (longitude, latitude, name) to the specified key.
redis.geoadd("buses", -74.0002041, 40.7178486, "Bus A")
redis.geoadd("buses", -73.9947324, 40.7258577, "Bus B")

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
# - `km` for kilometers
# - `m` for meters
# - `mi` for miles
# - `ft` for feet
p! redis.geodist("buses", "Bus A", "Bus B", "m")

# To search the index, the GEORADIUS and GEORADIUSBYMEMBER (for Redis versions less than 6.2)
# or GEOSEARCH (for versions older than 6.2) commands are also used.

p! redis.georadiusbymember("buses", "Bus A", 1, "mi")
p! redis.georadius("buses", -74.0002041, 40.7178486, 2, "km")

p! redis.geosearch("buses", "Bus A", 1, "mi")
p! redis.geosearch("buses", Redis::GeoCoordinate.new(-74.0002041, 40.7178486), 2, "km")

# Also search accept the parameters WITHDIST (display results + distance from the specified point/record)
# and WITHCOORD (display results + record coordinates),
# as well as the ASC or DESC sort option (sort by distance from the point):
p! redis.geosearch("buses", Redis::GeoCoordinate.new(-74.0002041, 40.7178486), 2, "km", withdist: true)
p! redis.geosearch("buses", Redis::GeoCoordinate.new(-74.0002041, 40.7178486), 2000, "m", withcoord: true, withdist: true, sort: "asc")

redis.zrem("buses", "Bus A")
redis.zrem("buses", "Bus B")
redis.del("buses")
