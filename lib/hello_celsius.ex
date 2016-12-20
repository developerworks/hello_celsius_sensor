defmodule HelloCelsius do
  use Application

  @moduledoc """
  Simple example to read temperature from DS18B20 temperature sensor
  """
  require Logger

  @base_dir "/sys/bus/w1/devices/"

  def start(_type, _args) do
    # Logger.debug "Start measuring temperature..."
    spawn(fn ->  read_temp_forever() end)
    {:ok, self}
  end

  def read_temp_forever do
    File.ls!(@base_dir)
      |> Enum.filter(&(String.starts_with?(&1, "28-")))
      |> Enum.each(&read_temp(&1, @base_dir))

    :timer.sleep(1000)
    read_temp_forever
  end

  def read_temp(sensor, base_dir) do
    sensor_data = File.read!("#{base_dir}#{sensor}/w1_slave")
    # Logger.debug("reading sensor: #{sensor}: #{sensor_data}")
    {temp, _} = Regex.run(~r/t=(\d+)/, sensor_data)
    |> List.last
    |> Float.parse
    Logger.debug "#{temp/1000} °C"
  end
end
