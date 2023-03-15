FROM python:3-alpine

ARG CLOUD_SDK_VERSION=402.0.0

RUN apk add --update --no-cache\
    busybox \
    bash \
    curl \
    which

SHELL ["/bin/bash", "-c"]

# Create directory and download gcloud cli
RUN mkdir /gcloud && curl -o /gcloud/google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz 

# Installing the package
RUN cd gcloud \
  # Unpack
  && tar -xvf /gcloud/google-cloud-sdk.tar.gz \
  # Delete Tar to reduce image size
  && rm /gcloud/google-cloud-sdk.tar.gz \
  # Run gcloud install script -q for quiet to prevent cli prompts 
  && sh /gcloud/google-cloud-sdk/install.sh -q --bash-completion=false --path-update=true --usage-reporting=false \
  # Cleanup Cache and Backup
  && rm -rf $(find /gcloud/google-cloud-sdk/ -regex ".*/__pycache__") \
  && rm -rf /gcloud/google-cloud-sdk/.install/.backup 
# Adding the package path to local
ENV PATH $PATH:/gcloud/google-cloud-sdk/bin
ENTRYPOINT [ "/bin/bash" ]