## Build the IG
FROM hl7fhir/ig-publisher-base:latest as builder
WORKDIR /build
COPY . /build

# Get the latest publisher - don't run the batch script but run the line directly
RUN curl -L https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o ./input-cache/publisher.jar --create-dirs
# Run the publisher - don't run the batch script but run the line directly
RUN java -jar ./input-cache/publisher.jar publisher -ig .


## Get all IG dependencies
FROM alpine:latest as downloader
RUN apk update && apk add jq curl
WORKDIR /ig

COPY --from=builder /build/output/package.tgz .
COPY ./docker/download_dependencies.sh .
RUN chmod +x ./download_dependencies.sh
RUN tar xzf package.tgz -C /tmp && \
    ./download_dependencies.sh /tmp/package


## Pack it together, and prepare for loading into fhir server
FROM alpine:latest
RUN apk update && apk add jq curl
RUN adduser -D ig
WORKDIR /home/ig

COPY --from=downloader /ig/package.tgz .
COPY --from=downloader /ig/dependencies ./dependencies/
COPY ./docker/find_ig.sh .
COPY ./docker/load_ig.sh .
RUN chmod +x find_ig.sh load_ig.sh

USER ig
ENTRYPOINT ["/home/ig/find_ig.sh"]