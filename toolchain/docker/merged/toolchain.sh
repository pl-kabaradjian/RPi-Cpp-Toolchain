#!/usr/bin/env bash

name="$1"
case "$name" in
rpi)
    echo "Raspberry Pi Zero and Raspberry Pi 1"
    target=armv6-rpi-linux-gnueabihf
    arch=armv6
    board=rpi
    dev=nodev
    ;;
rpi-dev)
    echo "Raspberry Pi Zero and Raspberry Pi 1 (without development tools)"
    target=armv6-rpi-linux-gnueabihf
    arch=armv6
    board=rpi
    dev=dev
    ;;
rpi3-armv8)
    echo "armv8 (without development tools)"
    target=armv8-rpi3-linux-gnueabihf
    arch=armv8
    board=rpi3
    dev=nodev
    ;;
rpi3-armv8-dev)
    echo "armv8 (with development tools)"
    target=armv8-rpi3-linux-gnueabihf
    arch=armv8
    board=rpi3
    dev=dev
    ;;
rpi3-aarch64)
    echo "aarch64 (without development tools)"
    target=aarch64-rpi3-linux-gnu
    arch=aarch64
    board=rpi3
    dev=nodev
    ;;
rpi3-aarch64-dev)
    echo "aarch64 (with development tools)"
    target=aarch64-rpi3-linux-gnu
    arch=aarch64
    board=rpi3
    dev=dev
    ;;
*)
    echo "Unknown option."
    echo "Choose either 'rpi', 'rpi-dev', 'rpi3-armv8', 'rpi3-armv8-develop', "
    echo "'rpi3-aarch64', or 'rpi3-aarch64-develop'."
    exit 1
    ;;
esac

set -ex

case "$dev" in
nodev)
    docker_target=build
    tag=$target
    ;;
dev)
    docker_target=developer-build
    tag=$target-dev
    ;;
esac

. env/$target.env
build_args=$(./env/env2arg.py env/$target.env)
pushd cross-build
docker build \
    --tag tttapa/rpi-cross:$tag ${build_args} \
    --target $docker_target \
    --cpuset-cpus=0-3 . 
popd