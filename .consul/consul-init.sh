# !/bin/bash

consul services register -name=identity -address=http://identity -port=8080

consul services register -name=catering -address=http://catering -port=8080

consul services register -name=commercial -address=http://commercial-api -port=80

consul services register -name=nutricionista -address=http://nutricionista -port=8080

consul services register -name=logistica -address=http://logistica -port=8080