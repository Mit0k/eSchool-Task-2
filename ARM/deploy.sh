#!/bin/bash

GROUP="arm_test"



az deployment group create \
  --name ExampleDeployment \
  --resource-group $GROUP \
  --template-file "./webapp.json" \
  --parameters @"./webapp.parameters.json"