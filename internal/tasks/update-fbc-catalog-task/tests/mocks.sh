#!/bin/bash
set -xe

# seed for the build status
yq -o json <<< '
items: 
- id: 1
  distribution_scope: "stage"
  fbc_fragment: "registry.io/image0@sha256:0000"
  internal_index_image_copy: "registry-proxy-stage.engineering.redhat.com/rh-osbs-stage/iib:1"
  logs:
    url: "https://fakeiib.host/api/v1/builds/1/logs"
  request_type: "fbc-operations"
  state: "in_progress"
  state_reason: "The request was initiated"
  state_history:
    - state: "in_progress"
      state_reason: "The request was initiated"
  user: "iib@kerberos"' > /tmp/build-seed

buildSeed=$(cat /tmp/build-seed)
buildJson=$(jq -cr '.items[0]' <<< "${buildSeed}")

export buildSeed buildJson calls

function mock_build_progress() {

    state_reason[1]="Resolving the fbc fragment"
    state_reason[2]="Resolving the container images"
    state_reason[3]="The FBC fragment was successfully added in the index image"

    encoded_script="$2"
    calls="$1"

    build="$(base64 -d <<< "$encoded_script")"
    if [ "$calls" -gt "${#state_reason[@]}" ]; then
        jq -cr . <<< "${build}"
    elif [ "$calls" -eq "${#state_reason[@]}" ]; then
        build=$(jq -rc '.state |= "complete"' <<< "$build")
        build=$(jq -rc '.state_reason |= "The FBC fragment was successfully added in the index image"' <<< "${build}")
        jq -rc --argjson progress "{ \"state\": \"complete\", \"state_reason\": \"${state_reason[$calls]}\" }" '.state_history |= [$progress] + .' <<< "${build}"
        exit
    else
        jq -rc --argjson progress "{ \"state\": \"in_progress\", \"state_reason\": \"${state_reason[$calls]}\" }" '.state_history |= [$progress] + .' <<< "${build}"
    fi
}

function curl() {
  shift
  case $1 in
  "https://fakeiib.host/builds?user=iib@kerberos&from_index=quay.io/scoheb/fbc-index-testing:latest")
    echo -en "${buildSeed}" 
    ;;
  "-u:")
    tempfile="$4"
    echo -e '{ "fbc_opt_in": true}' > "$tempfile"
    ;;
  "https://fakeiib.host/builds/1")
    echo "$@" >> mock_build_progress_calls
    mock_build_progress "$(awk 'END{ print NR }' mock_build_progress_calls)" "$(base64 <<< "${buildJson}")" | tee build_json
    export -n buildJson
    buildJson=$(cat build_json)
    export buildJson
    ;;
  "https://fakeiib.host/api/v1/builds/1/logs")
    echo "Logs are for weaks"
    ;;
  ":")
     set -x
    echo -en "${buildJson}" | jq -cr
    ;;
  *)
    echo ""
    ;;
  esac
}

function opm() {
  echo '{ "schema": "olm.bundle", "image": "quay.io/repo/image@sha256:abcd1234"}'
}

function base64() {
    echo "decrypted-keytab"
}

function kinit() {
    echo "Ok"
}

function skopeo() {
    shift
    if [[ "$@" == "--raw docker://registry-proxy-stage.engineering.redhat.com/rh-osbs-stage/iib:1" ]]; then
        echo '{"manifests": [ { "mediaType": "application/vnd.docker.distribution.manifest.v2+json", "digest": "sha256:000" }] }'
    fi
}

# the watch_build_state can't reach some mocks by default, so exporting them fixes it.
export -f curl
export -f mock_build_progress
