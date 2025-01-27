#!/bin/bash

# Получаем громкость основного выхода
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -n 1)

# Проверяем, выключен ли звук
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o "yes")

if [ "$MUTED" = "yes" ]; then
    echo "Muted"
else
    echo "$VOLUME"
fi

