#!/bin/bash


# 检查是否提供了 GPU ID
if [ -z "$1" ]; then
    echo "Usage: "
    echo "kill process on specific nvidia devices with <SPECIFIC_GPU_ID_GROUP> , example: [bash kill.sh [0,1,2]]"
    echo "or"
    echo "kill all gpu process with [bash kill.sh all] "
    exit 1
fi



GPU_ID=$1

if [ "$GPU_ID" = "all" ]; then
    echo "Find PIDS on all GPUs"
    PIDS=$(fuser -v /dev/nvidia* 2>/dev/null | sort -u)
    echo $PIDS
elif echo "$GPU_ID" | grep -Eq '^\[[0-9]+(,[0-9]+)*\]$'; then
    GPU_ID_CLEANED=$(echo "$GPU_ID" | tr -d '[]' | tr ',' ' ')
    for GPU in $GPU_ID_CLEANED; do
        PIDS=$(fuser -v /dev/nvidia$GPU 2>/dev/null | sort -u)
        echo "Find PIDS on GPU$GPU"
        echo $PIDS
    done
else
    echo "Usage: "
    echo "kill process on specific nvidia devices with <SPECIFIC_GPU_ID_GROUP> , example: [bash kill.sh [0,1,2]]"
    echo "or"
    echo "kill all gpu process with [bash kill.sh all] "
    exit 1
fi



# 检查是否有进程需要杀死
if [ -z "$PIDS" ]; then
    echo "No GPU-related processes found."
    exit 0
fi

echo "Killing processes: $PIDS"

# 终止所有相关进程
for PID in $PIDS; do
    if ps -p $PID > /dev/null 2>&1; then
        echo "Killing process $PID..."
        kill -9 $PID
    fi
done

echo "GPU-related processes have been killed."