FROM golang:1.18 as build

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change

COPY go.mod ./
RUN go mod download && go mod verify

COPY . .
RUN go build -o /app

FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /app /app

EXPOSE 3030

USER nonroot:nonroot

ENTRYPOINT ["/app"]