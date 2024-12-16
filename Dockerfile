FROM hashicorp/terraform:latest

RUN \
  apk update && \
  apk add bash py-pip curl && \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make && \
  pip install azure-cli --break-system-packages && \
  apk del --purge build 

ENTRYPOINT ["/bin/bash"]