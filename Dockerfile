# syntax=docker/dockerfile:1

##
## STEP 1 - BUILD
##

# specify the base image to  be used for the application, alpine or ubuntu
FROM golang:1.17-alpine AS build

# create a working directory inside the image
WORKDIR /app

# Set ENV variables
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64\
    GOPROXY=https://proxy.golang.org

# copy Go modules and dependencies to image
COPY go.mod ./
COPY go.sum ./

# download Go modules and dependencies
RUN go mod download

# copy directory files i.e all files ending with .go
COPY . .

# compile application
RUN go build -o /go-fiber 


##
## STEP 2 - DEPLOY
##
FROM scratch

WORKDIR /

COPY --from=build /go-fiber /go-fiber

EXPOSE 3000

ENTRYPOINT ["/go-fiber"]

