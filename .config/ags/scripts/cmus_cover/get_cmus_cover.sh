#!/usr/bin/env bash

XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
CMUS_CACHE_DIR="$XDG_CACHE_HOME/cmus_ags"
AGS_MEDIA_CACHE_DIR="$XDG_CACHE_HOME/ags/media"

track_path="$(cmus-remote -Q | grep file | head -n1 | awk -F 'file ' '{print $2}')"
track_basename="$(basename "$track_path")"

img_path="$CMUS_CACHE_DIR/$track_basename.png"
hash="$(echo -n "$track_path" | sha1sum | awk '{print $1}')"; hash_path="$AGS_MEDIA_CACHE_DIR/$hash" || hash_path=""

mkdir -p "$CMUS_CACHE_DIR"
mkdir -p "$AGS_MEDIA_CACHE_DIR"

if [[ -z "$( find "$CMUS_CACHE_DIR" -name "coverpath.txt" )" ]]; then
    touch "$CMUS_CACHE_DIR/coverpath.txt"
fi

if [[ -z "$(find "$AGS_MEDIA_CACHE_DIR" -name "$hash" )" ]]; then
    ffmpeg -ss 0:00 "$img_path" -i "$track_path"; mv "$img_path" "$hash_path" || hash_path=""
fi

echo "$hash_path" > "$CMUS_CACHE_DIR/coverpath.txt"

