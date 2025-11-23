#!/bin/bash

APP_NAME="disdim"
BUILD_DIR=".build/release"
APP_BUNDLE="${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "Building release binary..."
swift build -c release

echo "Creating App Bundle structure..."
rm -rf "${APP_BUNDLE}"
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

echo "Copying binary..."
cp "${BUILD_DIR}/${APP_NAME}" "${MACOS_DIR}/"

echo "Copying Info.plist..."
cp "Info.plist" "${CONTENTS_DIR}/"

echo "Signing app (ad-hoc)..."
codesign --force --deep --sign - "${APP_BUNDLE}"

echo "Done! ${APP_BUNDLE} created."
