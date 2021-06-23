#!/bin/bash

circleci config pack src > orb.yml
circleci orb publish orb.yml kenfdev/conftest-orb@dev:alpha
rm -rf orb.yml
