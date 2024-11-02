https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners

# Download
# Create a folder
$ mkdir actions-runner && cd actions-runner
# Download the latest runner package
$ curl -o actions-runner-linux-arm64-2.320.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-arm64-2.320.0.tar.gz
# Optional: Validate the hash
$ echo "bec1832fe6d2ed75acf4b7d8f2ce1169239a913b84ab1ded028076c9fa5091b8  actions-runner-linux-arm64-2.320.0.tar.gz" | shasum -a 256 -c
# Extract the installer
$ tar xzf ./actions-runner-linux-arm64-2.320.0.tar.gz

# Configure 
# Create the runner and start the configuration experience
$ ./config.sh --url https://github.com/edgeforge-labs/website --token BMPNJ7JVZOFMOZDPKQLMJEDHEUANM
# Last step, run it!
$ ./run.sh  


# Using your self-hosted runner
# Use this YAML in your workflow file for each job
runs-on: self-hosted