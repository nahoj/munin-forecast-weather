This is a Munin plugin that outputs weather data that was forecast by online sources *for the present time*.

This plugin will not give you a weather forecast for any future date. Instead it will store the forecasts (for e.g. the next day) and output them whenever they are due.

The plugin can output temperature (°C) and humidity (%) values.


## Install & config

For a default setup:

```bash
sudo make install
```

This will create 2 graphs: one for temperatures and one for humidity. You may wish do to otherwise by creating the symbolic links yourself (see the Makefile). The name of the links is not important.

In any case you need to edit the Munin configuration:


### Munin host (optional)

You may want to create a dedicated Munin host to separate the weather data from all your system graphs. In the master conf (e.g. `/etc/munin/munin.conf`):

```ini
# Your existing conf for a local munin-node
[my.own.domain]
    address 127.0.0.1
    use_node_name yes

# Add this
[own.domain;Weather]
    address 127.0.0.1
    use_node_name no
```

If you're already using the plugin and would like to create the separate host later, see [How to migrate Munin graph history](https://serverfault.com/questions/252572/how-to-migrate-munin-graph-history#252580).


### Plugin config

Then you need to configure the plugin in the munin-node conf (e.g. `/etc/munin/plugin-conf.d/munin-node`). Here is an example config. See below for available data sources.

```ini
[forecast_weather_*]
# If you created a dedicated Munin host
env.host_name Weather
# If you registered on Dark Sky
env.darksky_key xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# If you change this, make sure the file is read/writable by nobody:munin
# or the user the plugin runs as
env.db_file /var/cache/munin/forecast_weather.db
# If you use prevision-meteo.ch
env.place biot-06
# Positive or negative numbers. No N/S/E/W.
env.latitude 43.6286
env.longitude 7.0964

[forecast_weather_humidity]
env.graph_title Forecast humidity
# A field name is "field" followed by digits.
# Most parameters (e.g. latitude, advance) can be set either globally (above)
# or on a field-by-field basis (below).
env.field100_label Prevision-meteo 24h
# Advance and time resolution are expressed in seconds
env.field100_advance 86400
env.field100_time_resolution 3600
env.field100_type humidity

[forecast_weather_temperature]
env.graph_title Forecast temperature
env.field100_label Dark Sky current
# 0 for current time
env.field100_advance 0
# Munin typically runs every 5 minutes so a smaller time resolution
# makes little sense
env.field100_time_resolution 300
env.field100_type temperature
```

You may want to combine the forecast data with data from other Munin graphs, such as temperature and humidity sensor data from e.g. [this plugin](https://cweiske.de/usb-wde1-tools.htm). You can do this with the [graph_order](http://munin-monitoring.org/wiki/LoaningData) directive.


## Data sources

The plugin can show data from the following sources:

* [Dark Sky](https://darksky.net/). Worldwide forecasts. Freemium. You need to register online and set the darksky_key parameter in the munin-node conf. Accepts latitude/longitude only.

* [Prevision-meteo.ch](http://www.prevision-meteo.ch/). Forecasts for Switzerland, Belgium and France. Free, no registration required. Accepts locality identifier (preferred, to look up on the website) or latitude/longitude.
