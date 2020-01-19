# -----------------------------------------------------------------------------
# functions
# -----------------------------------------------------------------------------

function update() {
    brew update
    brew upgrade
    brew cask outdated | xargs brew cask reinstall
    mas upgrade
    brew cleanup -s
}

function setenv() {
    case $1 in
    proxy)
        local _proxy="http://proxy.kohls.com:3128"
        export http_proxy="${_proxy}"
        export https_proxy="${_proxy}"
        export HTTP_PROXY="${_proxy}"
        export HTTPS_PROXY="${_proxy}"
        export ALL_PROXY="${_proxy}"
        ;;
    -proxy)
        unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY
        ;;
    creds)
        export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/.creds/kohls/gcp/terraform.json"
        ;;
    -creds)
        unset GOOGLE_APPLICATION_CREDENTIALS
        ;;
    pynossl)
        export PYTHONHTTPSVERIFY="0"
        ;;
    -pynossl)
        unset PYTHONHTTPSVERIFY
        ;;
    *)
        echo "Need to specify which env varibles to set"
        ;;
    esac
}
