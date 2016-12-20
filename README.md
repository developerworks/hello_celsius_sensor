> 文本, 我会使用一个Elixir实现的模块函数去读取连接到树莓派的DS18B20温度传感器的温度数值.

文本假设你熟悉

- 数字电路基础
- Elixir编程基础

## 视频演示

- https://v.qq.com/x/page/q0357crk80y.html

## 原料

树莓派3, B型

DS18B20传感器

![t02](https://cloud.githubusercontent.com/assets/725190/21265400/3b2c75cc-c3dc-11e6-8916-82249d470ba6.png)

4.7KΩ 电阻(一分钱一颗)

![img_1633](https://cloud.githubusercontent.com/assets/725190/21337521/e2d12f74-c6a8-11e6-8963-d4475c8eb5be.png)

面包板(图片省略, 下文有)

公母头杜邦线

![img_1634](https://cloud.githubusercontent.com/assets/725190/21337523/e2d1eb08-c6a8-11e6-8b11-3b5fc24aabd0.png)



## 连接温度传感器

接线图

![ds18b201](https://cloud.githubusercontent.com/assets/725190/21337530/eaea7c42-c6a8-11e6-9ad3-71633d2f9e18.png)

面包板内部连通图

![breadboard-connections](https://cloud.githubusercontent.com/assets/725190/21265399/3af7eb04-c3dc-11e6-88d1-bc9810191d95.png)

面包板接线图

![img_1627](https://cloud.githubusercontent.com/assets/725190/21337525/e2d22654-c6a8-11e6-8cc3-9fef50419818.png)

> - 黑色为地线
> - 红色为3.3V板供直流电源, 对应PIN1
> - 黄色为数据线
> - 电阻连接在红色和黄色线之间

![img_1628](https://cloud.githubusercontent.com/assets/725190/21337526/e2d48840-c6a8-11e6-9401-0367aedef70b.png)


树莓派主板接线

![img_1629](https://cloud.githubusercontent.com/assets/725190/21337524/e2d1f45e-c6a8-11e6-90d5-14c137c1068d.png)

全体照

![img_1630](https://cloud.githubusercontent.com/assets/725190/21337522/e2d1cc86-c6a8-11e6-97e0-1acc1e6a5709.png)


## 创建一个新的Elixir Nerves项目

```
mix nerves.new hello_celsius_sensor --target rpi3
cd hello_celsius_sensor
mix deps.get
```

## 启用线路协议支持

下面的过程和描述和[覆盖启动分区中的文件](https://hexdocs.pm/nerves/advanced-configuration.html#overwriting-files-in-the-boot-partition)相关

修改 `config/config.exs`, 包含如下内容:

```elixir
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
```

创建 `rootfs-additions` 目录

```
mkdir -p config/rootsfs-additions/etc
cd config/rootsfs-additions/etc
vi erlinit.config
```

添加如下内容:

```
# Additional configuration for erlinit

# Turn on the debug prints
# -v

# Specify the UART port that the shell should use.
#-c tty1
-c ttyS0

# If more than one tty are available, always warn if the user is looking at
# the wrong one.
--warn-unused-tty

# Use dtach to capture the iex session so that it can be redirected
# to the app's GUI
#-s "/usr/bin/dtach -N /tmp/iex_prompt"

# Specify the user and group IDs for the Erlang VM
#--uid 100
#--gid 200

# Uncomment to hang the board rather than rebooting when Erlang exits
# --hang-on-exit

# Optionally run a program if the Erlang VM exits
#--run-on-exit /bin/sh

# Enable UTF-8 filename handling in Erlang and custom inet configuration
-e LANG=en_US.UTF-8;LANGUAGE=en;ERL_INETRC=/etc/erl_inetrc

# Mount the application partition
# See http://www.linuxfromscratch.org/lfs/view/6.3/chapter08/fstab.html about
# ignoring warning the Linux kernel warning about using UTF8 with vfat.
-m /dev/mmcblk0p3:/root:vfat::

# Erlang release search path
-r /srv/erlang

# Assign a unique hostname based on the board id
-d "/usr/bin/boardid -b rpi -n 4"
-n nerves-%.4s
```

注意`-c` 参数设置为 `ttyS0` 是为了能够通过开发电脑查看到树莓派的输出信息, 请参考[使用 Elixir 开发嵌入式系统: 串口调试](https://segmentfault.com/a/1190000007785009)

```
cp deps/rpi3/nerves_system_rpi3/fwup.conf config
```

修改 `file-resource config.txt` 的位置, 其中 `NERVES_APP` 为当前项目的根目录.

```
file-resource config.txt {
    host-path = "${NERVES_APP}/config/rpi/config.txt"
}
```

复制 `config.txt` 文件.

```
cp deps/rpi3/nerves_system_rpi3/config.txt config/rpi
```

DS18B20 使用 [Dallas 1-Wire protocol](https://en.wikipedia.org/wiki/1-Wire) 协议. Nerves 提供了对 1-Wire 协议的支持, 只需要在 `config.txt` 配置文件激活这个参数即可.

![t06](https://cloud.githubusercontent.com/assets/725190/21265403/3b3472a4-c3dc-11e6-9a58-7f0bdcad64ac.png)


## 代码库

- https://github.com/developerworks/hello_celsius_sensor

## 参考资料

- [Elixir Nerves for measuring temperature from a DS18B20 sensor on a Raspberry Pi](http://www.carstenblock.org/post/project-excelsius/)
- [Raspberry Pi DS18B20 Temperature Sensor Tutorial](https://www.youtube.com/watch?v=aEnS0-Jy2vE)
