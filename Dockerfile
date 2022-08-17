# syntax=docker/dockerfile:1

##
## STEP 1 - BUILD
##

# specify the base image to  be used for the application, alpine or ubuntu
FROM golang:1.18 AS build

# create a working directory inside the image
WORKDIR /app

# Set ENV variables
ENV GO111MODULE=on\
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64\
   # GOFLAGS=-mod=vendor\
    GOPROXY=https://proxy.golang.org

# copy Go modules and dependencies to image
#COPY go.mod ./
#COPY go.sum ./
COPY go.mod go.mod
COPY go.sum go.sum

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

