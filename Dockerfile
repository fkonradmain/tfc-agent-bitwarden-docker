FROM hashicorp/tfc-agent:latest

# Source: https://developer.hashicorp.com/terraform/cloud-docs/agents/agents#optional-configuration-run-an-agent-using-docker
# Execute the next steps as root user
USER root

# Download and install the Bitwarden CLI
RUN wget -O /usr/local/bin/bw "https://vault.bitwarden.com/download/?app=cli&platform=linux" && \
chmod +x /usr/local/bin/bw

# Also install sudo. The container runs as a non-root user, but people may rely on
# the ability to apt-get install things. --> Guidance from Terraform Docs
RUN apt-get update && \
  apt-get install sudo -y && \
  apt-get clean

# Permit tfc-agent to use sudo apt-get commands.
RUN echo 'tfc-agent ALL=NOPASSWD: /usr/bin/apt-get , /usr/bin/apt' >> /etc/sudoers.d/50-tfc-agent

USER tfc-agent
