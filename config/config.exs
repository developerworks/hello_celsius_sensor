use Mix.Config

# 日志
config :logger, :console,
  level: :debug,
  format: "$date $time $metadata[$level] $message\n",
  handle_sasl_reports: true,
  handle_otp_reports: true,
  utc_log: true

# 覆盖
config :nerves, :firmware,
  rootfs_additions: "config/rootfs-additions"

# 固件配置
config :nerves, :firmware,
  fwup_conf: "config/rpi/fwup.conf"
