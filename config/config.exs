use Mix.Config

# ------------
# 网络配置
# ------------
# 产品环境中, 需要提供一个Web界面让用户设置WIFI连接信息,
# 并且该设置信息需要存储到持久存储中, 比如SQLITE数据库或配置文件.

config :fw, :eth0,
  mode: "dhcp"

config :fw, :eth0_static,
  mode: "static",
  ip: "192.168.0.201",
  router: "192.168.0.1",
  mask: "24",
  subnet: "255.255.255.0",
  dns: ["192.168.0.1","8.8.8.8","8.8.4.4"],
  hostname: "nerves-rpi3"

config :fw, :wlan0,
  ssid: "gx888888",
  key_mgmt: :"WPA-PSK",
  psk: "gx888888"

config :fw, :wlan0_static,
  ipv4_address_method: :static,
  ipv4_address: "192.168.0.200",
  ipv4_subnet_mask: "255.255.255.0",
  domain: "www.totoro-game.com",
  nameservers:  ["192.168.0.1", "8.8.8.8", "8.8.4.4", "114.114.114.114"],
  ssid: "gx888888",
  key_mgmt: "WPA-PSK",
  psk: "gx888888"

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

# 同步时间
config :nerves_ntp, :ntpd, "/usr/sbin/ntpd"

# 时间服务器列表
config :nerves_ntp, :servers, [
  "0.pool.ntp.org",
  "1.pool.ntp.org",
  "2.pool.ntp.org",
  "3.pool.ntp.org"
]


