#!/bin/bash
set -e

cd /home/container

./hytale-downloader/hytale-downloader-linux --print-version

VERSION_CACHE_FILE="version.cache"

LATEST_VERSION=$(./hytale-downloader/hytale-downloader-linux --print-version 2>/dev/null || true)

CACHED_VERSION=""
if [[ -f "$VERSION_CACHE_FILE" ]]; then
	CACHED_VERSION=$(cat "$VERSION_CACHE_FILE")
fi

NEED_DOWNLOAD=0

if [[ -z "$CACHED_VERSION" ]]; then
	NEED_DOWNLOAD=1
elif [[ "$LATEST_VERSION" != "$CACHED_VERSION" ]]; then
	NEED_DOWNLOAD=1
fi

# If HYTALE_SERVER_SESSION_TOKEN isn't set, assume the user will log in themselves, rather than a host's GSP
if [[ -z "$HYTALE_SERVER_SESSION_TOKEN" ]]; then
	if [[ "$NEED_DOWNLOAD" == "1" ]]; then
		echo -e "Downloading Hytale server..."
		./hytale-downloader/hytale-downloader-linux \
			-patchline "$HYTALE_PATCHLINE" \
			-download-path HytaleServer.zip

		unzip -o HytaleServer.zip -d .
		
		# Fix problem with date and AOT cache when unzip
		NOW=$(date +%Y%m%d%H%M.%S)
		date +%Y%m%d%H%M.%S
		touch -t "$NOW" Server/HytaleServer.jar
		touch -t "$NOW" Server/HytaleServer.aot

		rm -f HytaleServer.zip

		if [[ -n "$LATEST_VERSION" ]]; then
			echo "$LATEST_VERSION" > "$VERSION_CACHE_FILE"
		fi
	else
		echo -e "Hytale is already up to date."
	fi
elif [[ -f "HytaleMount/HytaleServer.zip" ]]; then
	unzip -o HytaleMount/HytaleServer.zip -d .
elif [[ -f "HytaleMount/Assets.zip" ]]; then
	ln -s -f HytaleMount/Assets.zip Assets.zip
elif [[ -f "Server/Assets.zip" ]]; then
	ln -s -f Server/Assets.zip Assets.zip
elif [[ -f "HytaleServer.zip" ]]; then
	unzip -o HytaleServer.zip -d .
fi

# Download the latest hytale-sourcequery plugin if enabled
if [ "${INSTALL_SOURCEQUERY_PLUGIN}" == "1" ]; then
	mkdir -p mods
	echo -e "Downloading latest hytale-sourcequery plugin..."
	LATEST_URL=$(curl -sSL https://api.github.com/repos/physgun-com/hytale-sourcequery/releases/latest \
		| grep -oP '"browser_download_url":\s*"\K[^"]+\.jar' || true)
	if [[ -n "$LATEST_URL" ]]; then
		curl -sSL -o mods/hytale-sourcequery.jar "$LATEST_URL"
		echo -e "Successfully downloaded hytale-sourcequery plugin to mods folder."
	else
		echo -e "Warning: Could not find hytale-sourcequery plugin download URL."
	fi
fi

if [[ -f config.json && -n "$HYTALE_MAX_VIEW_RADIUS" ]]; then
	jq ".MaxViewRadius = $HYTALE_MAX_VIEW_RADIUS" config.json > config.tmp.json && mv config.tmp.json config.json
fi

/java.sh $@
