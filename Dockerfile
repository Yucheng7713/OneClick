FROM ubuntu:latest

# Install curl
RUN apt-get update \
&& apt-get install -y curl

# Install wget
RUN apt-get install -y wget

# Install unzip
RUN apt-get install -y unzip

# Install ssh server
RUN apt install -y openssh-server

# Install terraform
RUN wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip \
&& unzip terraform_0.11.13_linux_amd64.zip \
&& mv terraform /usr/local/bin/

# Install kubeclt
RUN curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.12.9/bin/linux/amd64/kubectl \
&& chmod +x ./kubectl \
&&  mv ./kubectl /usr/local/bin/kubectl

# Install kops
RUN curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 \
&& chmod +x kops-linux-amd64 \
&& mv kops-linux-amd64 /usr/local/bin/kops

COPY ./terraform /terraform
COPY ./k8s /k8s

RUN cd terraform \
&& ssh-keygen -b 2048 -t rsa -f /tmp/sshkey -q -N ""


CMD ["bin/bash"]
