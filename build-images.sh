#!/bin/bash

# Terminate on error
set -e

POSTGRES_VERSION="16.20240405"
ODOO_VERSION="16.20240405"

# Prepare variables for later use
images=()
# The image will be pushed to GitHub container registry
repobase="${REPOBASE:-ghcr.io/innovyou}"
# Configure the image name
reponame="odoo"

# Create a new empty container image
container=$(buildah from scratch)

# Reuse existing nodebuilder-odoo container, to speed up builds
if ! buildah containers --format "{{.ContainerName}}" | grep -q nodebuilder-odoo; then
    echo "Pulling NodeJS runtime..."
    buildah from --name nodebuilder-odoo -v "${PWD}:/usr/src:Z" docker.io/library/node:lts
fi

echo "Build static UI files with node..."
buildah run --env="NODE_OPTIONS=--openssl-legacy-provider" --workingdir=/usr/src/ui --env="NODE_OPTIONS=--openssl-legacy-provider" nodebuilder-odoo sh -c "yarn install && yarn build"

# Add imageroot directory to the container image
buildah add "${container}" imageroot /imageroot
buildah add "${container}" ui/dist /ui
# Setup the entrypoint, ask to reserve one TCP port with the label and set a rootless container
buildah config --entrypoint=/ \
    --label="org.nethserver.authorizations=node:fwadm traefik@node:routeadm" \
    --label="org.nethserver.tcp-ports-demand=3" \
    --label="org.nethserver.rootfull=0" \
    --label="org.nethserver.images=docker.io/innovyou/ns8-postgres:$POSTGRES_VERSION docker.io/innovyou/ns8-odoo:$ODOO_VERSION" \
    "${container}"
# Commit the image
buildah commit "${container}" "${repobase}/${reponame}"

# Append the image URL to the images array
images+=("${repobase}/${reponame}")

#
# NOTICE:
#
# It is possible to build and publish multiple images.
#
# 1. create another buildah container
# 2. add things to it and commit it
# 3. append the image url to the images array
#

#
# Setup CI when pushing to Github.
# Warning! docker::// protocol expects lowercase letters (,,)
if [[ -n "${CI}" ]]; then
    # Set output value for Github Actions
    printf "images=%s\n" "${images[*],,}" >> "${GITHUB_OUTPUT}"
else
    # Just print info for manual push
    printf "Publish the images with:\n\n"
    for image in "${images[@],,}"; do printf "  buildah push %s docker://%s:%s\n" "${image}" "${image}" "${IMAGETAG:-latest}" ; done
    printf "\n"
fi
