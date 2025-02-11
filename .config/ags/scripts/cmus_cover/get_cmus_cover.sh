#!/usr/bin/env bash

track_path=$(cmus-remote -Q | grep file | head -n1 | awk -F 'file ' '{print $2}')
track_basename=$(basename "$track_path")

cmus_cache="$HOME/.cache/cmus_ags"
media_cache="$HOME/.cache/ags/media"

img_path="$cmus_cache/$track_basename.png"
hash=$(echo -n "$track_path" | sha1sum | awk '{print $1}'); hash_path="$media_cache/$hash" || hash_path=""

mkdir -p "$cmus_cache"
mkdir -p "$media_cache"

if [[ -z "$( find "$cmus_cache" -name "coverpath.txt" )" ]]; then
    touch "$cmus_cache/coverpath.txt"
fi

if [[ -z "$(find "$media_cache" -name "$hash" )" ]]; then
    ffmpeg -ss 0:00 "$img_path" -i "$track_path" && mv "$img_path" "$hash_path" || hash_path=""
fi

echo "$hash_path" > "$cmus_cache/coverpath.txt"

