FROM openjdk:8u212-jre-alpine AS build

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=build /usr /usr
COPY --from=build /lib /lib
COPY --from=build /etc/ssl /etc/ssl