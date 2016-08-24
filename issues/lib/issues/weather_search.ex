defmodule Issues.WeatherSearch do

  require Logger


  @user_agent [ {"User-agent", "Elixir ian@iancharters.com"} ]
  @weather_url Application.get_env(:issues, :weather_url)

  def fetch(airport_code) do
      Logger.info "Fetching weather info for #{airport_code}"
      weather_url(airport_code)
      |> HTTPoison.get()
      |> handle_response
  end

  def weather_url(airport_code) do
    "#{@weather_url}/#{airport_code}.xml"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end
    { :ok, body }
  end

  def handle_response({:ok, %{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
    { :error, body }
  end
end
