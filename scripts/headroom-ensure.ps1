$container = docker ps -a --filter "name=^headroom-proxy$" --format "{{.ID}}" 2>$null
if ($container) {
    $entrypoint = docker inspect $container --format "{{json .Config.Entrypoint}}" 2>$null
    if ($entrypoint -ne '["headroom"]') {
        docker stop $container 2>$null | Out-Null
        docker rm $container 2>$null | Out-Null
        $container = $null
    }
}
if (-not $container) {
    docker run -d --entrypoint headroom --name headroom-proxy --restart unless-stopped -p 8787:8787 -v headroom-data:/data -e ANTHROPIC_TARGET_API_URL=http://host.docker.internal:6655/anthropic -e HEADROOM_TELEMETRY=off -e HEADROOM_CODE_AWARE_ENABLED=1 -e HEADROOM_HOST=0.0.0.0 -e HEADROOM_OUTPUT_SHAPER=1 -e HEADROOM_DATA_DIR=/data headroom-extras:latest proxy --host 0.0.0.0 --port 8787 2>&1
} else {
    docker start $container 2>&1
}
