#!/usr/bin/env bash
installed_version=$(go version | awk '{print $3}' | sed -e 's/go//')
version="1.20.7"
if [[ ${installed_version} != ${version} ]]; then
    curl -JLO https://go.dev/dl/go${version}.linux-amd64.tar.gz
fi

echo "Install Go Version ${version}"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go${version}.linux-amd64.tar.gz

echo "Update \$PATH"
grep --quiet --fixed-strings --line-regexp 'export PATH=$PATH:/usr/local/go/bin' ~/.bashrc || echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

echo "Install Go Tools"
go install -v golang.org/x/tools/gopls@latest