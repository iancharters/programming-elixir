defmodule Issues.CLI do
    @default_count 4

    import Quinn

    @moduledoc """
    Handle the command line parsing and the dispatch to
    the various functions that end up generating a
    table of the last _n_ issues in a github project
    """

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.
  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases: [ h: :help ])
  case parse do
    { [ help: true ], _, _ }            -> :help
    { _, [ user, project, count ], _ }  -> { user, project, String.to_integer(count) }
    { _, [ user, project ], _ }         -> { user, project, @default_count }
    {_, airport_code, _ }               -> airport_code
    _                                   -> :help
    end
  end

  def process(:help) do
    IO.puts """
    Github Issues:

    usage: issues <user> <project> [ count | #{@default_count} ]

    Weather Lookup:

    usage: issues <airport code>
    """

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> convert_to_maps
    |> sort_into_ascending_order
    |> Enum.take(count)
    |> columns("number", "created_at", "title")
  end

@doc """
Fetches the XML file and parses the individual fields.  Prints out the result
in a table.
"""

  def process(airport_code) do

    map = Map.new()
    #Uses HTTPoison to request the XML page.  Quinn parses this XML and
    #puts it into the result variable without a list.

    [result | _ ] = Issues.WeatherSearch.fetch(airport_code)
                    |> decode_response
                    |> Quinn.parse

    location = Quinn.find(result, :location)
      |> List.first
      |> Map.get(:value)

    station_id = Quinn.find(result, :station_id)
      |> List.first
      |> Map.get(:value)

    observation_time = Quinn.find(result, :observation_time)
      |> List.first
      |> Map.get(:value)

    latitude = Quinn.find(result, :latitude)
      |> List.first
      |> Map.get(:value)

    longitude = Quinn.find(result, :longitude)
      |> List.first
      |> Map.get(:value)

    temp_c = Quinn.find(result, :temp_c)
      |> List.first
      |> Map.get(:value)

    dewpoint_c = Quinn.find(result, :dewpoint_c)
      |> List.first
      |> Map.get(:value)

    relative_humidity = Quinn.find(result, :relative_humidity)
      |> List.first
      |> Map.get(:value)

    wind_mph = Quinn.find(result, :wind_mph)
      |> List.first
      |> Map.get(:value)

    map =
        %{  location: List.first(location),
            station_id: List.first(station_id),
            observation_time: List.first(observation_time),
            latitude: List.first(latitude),
            longitude: List.first(longitude),
            temp_c: List.first(temp_c),
            dewpoint_c: List.first(dewpoint_c),
            relative_humidity: List.first(relative_humidity),
            wind_mph: List.first(wind_mph),
        }

    weather_table(map)

  end

  def weather_table(map) do
    "Location: #{Map.get(map, :location)} (#{Map.get(map, :station_id)})\n" <>
    "Observation time: #{Map.get(map, :observation_time)}\n" <>
    "Lat&Long: #{Map.get(map, :latitude)} / #{Map.get(map, :longitude)}\n" <>
    "Temperature: #{Map.get(map, :temp_c)}c\n" <>
    "Dewpoint: #{Map.get(map, :dewpoint_c)}c\n" <>
    "Relative Humidity: #{Map.get(map, :relative_humidity)}%\n" <>
    "Wind (mph): #{Map.get(map, :wind_mph)}"
    |> IO.puts
  end

  def columns(map, c1, c2, c3) do
    IO.puts "#    | created_at           | title
-----+----------------------+-----------------------------------------"

    Enum.each(map, fn x ->
      IO.puts "#{Map.get(x, c1)} | #{Map.get(x, c2)} | #{Map.get(x, c3)}"
    end)
  end

  def sort_into_ascending_order(list_of_issues) do
    Enum.sort list_of_issues, fn i1, i2 ->
      i1["created_at"] <= i2["created_at"]
    end
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def convert_to_maps(list) do
    list
    |> Enum.map(&(Enum.into(&1, Map.new)))
  end
end
