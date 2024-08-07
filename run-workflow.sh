#!/bin/bash

for i in {1..400}; do
    gh workflow run ci-build.yml --ref=flyci-test
done
