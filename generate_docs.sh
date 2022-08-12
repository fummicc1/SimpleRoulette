#!/bin/bash

swift package --allow-writing-to-directory docs \
    generate-documentation --target SimpleRoulette \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path SimpleRoulette \
    --output-path docs

rm docs/index.html
cp README.md docs/index.md
