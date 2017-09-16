PLUGINS = /etc/munin/plugins

install: lninstall

lninstall:
	# Link plugin code
	ln -sf $(abspath forecast_weather_) $(PLUGINS)/forecast_weather_temperature
	ln -sf $(abspath forecast_weather_) $(PLUGINS)/forecast_weather_humidity

	# Get rights to standard location for DB file
	chown munin:munin /var/cache/munin
	chmod g=rwx /var/cache/munin

uninstall:
	rm -f $(PLUGINS)/forecast_weather_temperature
	rm -f $(PLUGINS)/forecast_weather_humidity

.PHONY: install lninstall uninstall


README.html: README.md
	pandoc -s -f markdown_github $^ -o $@

clean:
	rm -f README.html
.PHONY: clean
