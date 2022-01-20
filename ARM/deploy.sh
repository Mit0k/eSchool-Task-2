#!/bin/bash

az deployment group create \
  --name ExampleDeployment \
  --resource-group $1 \
  --template-file "./webapp.json" \
  --parameters @"./webapp.parameters.json"