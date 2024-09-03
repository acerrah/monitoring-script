#!/bin/bash

cpu_load=$(uptime | awk -F, '{print $4}' | awk -F" " '{print $3}')
memory_usage=$(free -m | grep Mem | awk '{print $3/$2 * 100}')
disk_space_usage=$(df -h / | grep '/' | awk '{print $5}' | tr -d '%')

cpu_check=$(echo "$cpu_load > 6.0" | bc -l)
memory_check=$(echo "$memory_usage > 80" | bc -l)
disk_check=$(echo "$disk_space_usage > 80" | bc -l)

if [ -f /tmp/cpu_state ]; then
    cpu_state=$(cat /tmp/cpu_state)
else
    cpu_state=0
fi

if [ -f /tmp/memory_state ]; then
    memory_state=$(cat /tmp/memory_state)
else
    memory_state=0
fi

if [ -f /tmp/disk_state ]; then
    disk_state=$(cat /tmp/disk_state)
else
    disk_state=0
fi

if [ "$cpu_check" -eq 1 ] && [ "$cpu_state" -eq 0 ]; then
    message="Warning CPU Load: $cpu_load"
    curl -s -X POST "https://api.telegram.org/bot<bot_token>/sendMessage" -d "chat_id=<chat_id>&text=$message"
    echo 1 > /tmp/cpu_state
fi

if [ "$cpu_check" -eq 0 ] && [ "$cpu_state" -eq 1 ]; then
    message="CPU Load: $cpu_load"
    curl -s -X POST "https://api.telegram.org/bot<bot_token>/sendMessage" -d "chat_id=<chat_id>&text=$message"
    echo 0 > /tmp/cpu_state
fi

if [ "$memory_check" -eq 1 ] && [ "$memory_state" -eq 0 ]; then
    message="Warning Memory Usage: $memory_usage%"
    curl -s -X POST "https://api.telegram.org/bot<bot_token>/sendMessage" -d "chat_id=<chat_id>&text=$message"
    echo 1 > /tmp/memory_state
fi

if [ "$memory_check" -eq 0 ] && [ "$memory_state" -eq 1 ]; then
    message="Memory Usage: $memory_usage%"
    curl -s -X POST "https://api.telegram.org/bot<bot_token>/sendMessage" -d "chat_id=<chat_id>&text=$message"
    echo 0 > /tmp/memory_state
fi

if [ "$disk_check" -eq 1 ] && [ "$disk_state" -eq 0 ]; then
    message="Warning Disk Space Usage: $disk_space_usage%"
    curl -s -X POST "https://api.telegram.org/bot<bot_token>/sendMessage" -d "chat_id=<chat_id>&text=$message"
    echo 1 > /tmp/disk_state
fi

if [ "$disk_check" -eq 0 ] && [ "$disk_state" -eq 1 ]; then
    message="Disk Space Usage: $disk_space_usage%"
    curl -s -X POST "https://api.telegram.org/bot<bot_token>/sendMessage" -d "chat_id=<chat_id>&text=$message"
    echo 0 > /tmp/disk_state
fi
