#!/usr/bin/env bats

load common

@test "Test for hot code changes." {
  cd sources/hotcode

  dork-compose up -d

  # Test if the http service is available and running.
  docker ps | grep 'hotcode_http_1'

  # Sleep to wait for the container to boot.
  sleep 1

  get hotcode.dork | grep 'This is a test.'
  rm html/index.html && echo "This is a hotcode test." >> html/index.html
  get hotcode.dork | grep 'This is a hotcode test.'
  rm html/index.html && echo "This is a test." >> html/index.html

  dork-compose down

  # Test if the http service has been removed.
  ! docker ps -a | grep 'hotcode_http_1'
}