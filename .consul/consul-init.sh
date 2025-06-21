# !/bin/bash

consul services register -name=identity -address=identity -port=8080

consul services register -name=catering -address=catering -port=8080

consul services register -name=commercial -address=commercial-api -port=80

consul services register -name=nutricionista -address=nutricionista -port=8080