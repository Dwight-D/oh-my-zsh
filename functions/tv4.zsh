TV4_DIR=~/work/tv4

export AWS_PROFILE=910881736194_Administrator

function tv4() {
    cd $TV4_DIR/code
}

functions awscred() {
    xclip -selection clipboard -o > ~/.aws/credentials
}

functions vimond_auth() {
    source $TV4_DIR/secrets/vimond.staging.env
    curl --request POST \
      --url "https://mtv-first-vcc.vimond.auth0.com/oauth/token" \
      --header 'content-type: application/json' \
      --data "{\"client_id\":\"$VIMOND_FI_CLIENT_ID\",
      \"client_secret\":\"$VIMOND_FI_CLIENT_SECRET\",
      \"audience\":\"https://mtv-first-vcc.vimond.vcc.com/\",
      \"grant_type\":\"client_credentials\"}"
}

alias tvmtf="$TV4_DIR/code/tf-bootstrap/bin/tvm-tf.sh"

alias tv4aws="$TV4_DIR/code/tf-bootstrap/bin/awscredentials.sh"
