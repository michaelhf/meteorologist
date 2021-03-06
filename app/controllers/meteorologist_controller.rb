require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    url_safe_street_address = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the string @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the string url_safe_street_address.
    # ==========================================================================

    url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + url_safe_street_address
    raw_data = open(url).read

    parsed_data = JSON.parse(raw_data)

    lat = parsed_data["results"][0]["geometry"]["location"]["lat"]

    lng = parsed_data["results"][0]["geometry"]["location"]["lng"]

    url2 = "https://api.forecast.io/forecast/00cf5a994a1ac5f348ee0fdb4cd345ca/" + lat.to_s + "," + lng.to_s
    raw_data2 = open(url2).read

    parsed_data2 = JSON.parse(raw_data2)

    @current_temperature = parsed_data2["currently"]["apparentTemperature"]

    @current_summary = parsed_data2["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data2["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data2["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data2["daily"]["summary"]

    render("street_to_weather.html.erb")
  end
end
