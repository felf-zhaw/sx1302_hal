#!/bin/sh

# This script is intended to be used on SX1302 CoreCell platform, it performs
# the following actions:
#       - export/unpexort GPIO23 and GPIO18 used to reset the SX1302 chip and to enable the LDOs
#       - export/unexport GPIO22 used to reset the optional SX1261 radio used for LBT/Spectral Scan
#
# Usage examples:
#       ./reset_lgw.sh stop
#       ./reset_lgw.sh start

# GPIO mapping has to be adapted with HW
#
GPIO_CHIP="gpiochip0"

# GPIO offsets
SX1302_RESET_PIN=23
SX1302_POWER_EN_PIN=18
SX1261_RESET_PIN=22
AD5338R_RESET_PIN=13

WAIT_GPIO() {
    sleep 0.1
}

set_gpio() {
    local pin=$1
    local value=$2

    gpioset --mode=exit "$GPIO_CHIP" "$pin=$value"
}

reset() {
    echo "CoreCell reset through GPIO$SX1302_RESET_PIN..."
    echo "SX1261 reset through GPIO$SX1261_RESET_PIN..."
    echo "CoreCell power enable through GPIO$SX1302_POWER_EN_PIN..."
    echo "CoreCell ADC reset through GPIO$AD5338R_RESET_PIN..."

    # Power enable
    set_gpio $SX1302_POWER_EN_PIN 1
    WAIT_GPIO

    # SX1302 reset pulse
    set_gpio $SX1302_RESET_PIN 1
    WAIT_GPIO
    set_gpio $SX1302_RESET_PIN 0
    WAIT_GPIO

    # SX1261 reset pulse
    set_gpio $SX1261_RESET_PIN 0
    WAIT_GPIO
    set_gpio $SX1261_RESET_PIN 1
    WAIT_GPIO

    # AD5338R reset pulse
    set_gpio $AD5338R_RESET_PIN 0
    WAIT_GPIO
    set_gpio $AD5338R_RESET_PIN 1
    WAIT_GPIO
}

case "$1" in
    start)
        reset
        ;;
    stop)
        echo "Stopping/resetting SX1302..."
        reset
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac

exit 0


exit 0
