# RaENV - Rancher Environment Manager

**Currently Non-Functional! In Planning**

A CLI tools that enables fast switching between Rancher environment variable sets. Useful for variable storage/retreival and [rancher-compose]() operation.

## Commands & Flags

```sh
raenv help

# List all stored environments
raenv ls

# List specific environment
raenv ls myEnv1
raenv get myEnv1

# Set a new environment
raenv set myEnv1

# Copy an environment
raenv cp myEnv1 myEnv2

# Rename an environment
raenv mv myEnv1 myEnv2

# Parse a specific .raenv file
raenv -f ./.custom-raenv

```

## Installation

- git clone
- npm install -g raenv
- go get github.com/emcniece/raenv
- docker pull emcniece/raenv

## How It Works

Environments are stored in a ~/.raenv file. The syntax is basic YML:

```
[myEnv1]
url=http://localhost:8080
access=xxxxxxxxxxxxxxxxxx
secret=yyyyyyyyyyyyyyyyyy
```

Built with [Cobra](https://github.com/spf13/cobra)

## Building

## Future Consideration

- Get environment stats?