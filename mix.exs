defmodule HelloCelsiusSensor.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi3"

  def project do
    [app: :hello_celsius_sensor,
     version: "0.1.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.2.1"],

     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",

     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps() ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {HelloCelsiusSensor, []},
      applications: [
        :logger,
        :nerves_firmware_http,
        :nerves_interim_wifi,
        :nerves_lora_gateway,
        :nerves_networking,
        :nerves_ntp,
        :nerves_uart
      ]
    ]
  end

  def deps do
    [
      {:nerves, "~> 0.4.0"},
      {:nerves_firmware_http, github: "nerves-project/nerves_firmware_http"},
      {:nerves_interim_wifi, github: "nerves-project/nerves_interim_wifi"},
      {:nerves_lora_gateway, github: "developerworks/nerves_lora_gateway"},
      {:nerves_networking, github: "nerves-project/nerves_networking"},
      {:nerves_ntp, "~> 0.1.1"},
      {:nerves_uart, "~> 0.1.1"}
    ]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
