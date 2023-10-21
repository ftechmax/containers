#!/usr/bin/env bash
export PYTHONUNBUFFERED=1

echo "Container is running"

# # Sync venv to workspace to support Network volumes
# echo "Syncing venv to workspace, please wait..."
# rsync -au /venv/ /workspace/venv/
# rm -rf /venv

# Sync Kohya_ss to workspace to support Network volumes
echo "Syncing Kohya_ss to workspace, please wait..."
mkdir -p /workspace/kohya_ss
rsync -au /kohya_ss/ /workspace/kohya_ss/
rm -rf /kohya_ss

echo "Fixing Kohya_ss venv..."
/fix_venv.sh /kohya_ss/venv /workspace/kohya_ss/venv

# # Configure accelerate
# echo "Configuring accelerate..."
# mkdir -p /root/.cache/huggingface/accelerate
# mv /accelerate.yaml /root/.cache/huggingface/accelerate/default_config.yaml

# Create logs directory
mkdir -p /workspace/logs

# # Start application manager
# cd /workspace/app-manager
# npm start > /workspace/logs/app-manager.log 2>&1 &

if [[ ${DISABLE_AUTOLAUNCH} ]]
then
    echo "Auto launching is disabled so the applications will not be started automatically"
    echo "You can launch them manually using the launcher scripts:"
    echo ""
    echo "   Kohya_ss"
    echo "   ---------------------------------------------"
    echo "   /start_kohya.sh"
else
    /start_kohya.sh
fi

if [ ${ENABLE_TENSORBOARD} ];
then
    /start_tensorboard.sh
fi

echo "All services have been started"