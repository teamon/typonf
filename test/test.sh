#!/bin/bash
set -eu

export MIX_ENV=prod
export REPLACE_OS_VARS=true

export LOG_LEVEL=warn
export STR_VAR=hi
export INT_VAR=123
export BOOL_VAR=true

cd $(dirname $0)/testapp
mkdir -p rel/hooks
rm -f rel/hooks/typonf.sh
cp ../../typonf.sh rel/hooks/typonf.sh
mix deps.get
mix compile
mix release --no-tar --verbose
_build/prod/rel/testapp/bin/testapp console
