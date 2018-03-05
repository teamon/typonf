# Typed Runtime configuration for Elixir/Erlang

[Distillery's `REPLACE_OS_VARS`](https://github.com/bitwalker/distillery/blob/master/docs/Runtime%20Configuration.md#vmargs) is cool, but it can provide only binary values.
This tiny script will cast your runtime, ENV-based configuration to
proper values (atoms, integers, booleans).

Have you ever wanted to set the logger level in runtime?

```
# config/prod.exs
config :logger, level: "${LOG_LEVEL}"

# LOG_LEVEL=warn
iex(hello@127.0.0.1)3> Logger.warn "hello"
** (FunctionClauseError) no function clause matching in Logger.level_to_number/1

    The following arguments were given to Logger.level_to_number/1:

        # 1
        "warn"
```

Now you can!

```
# config/prod.exs
config :logger, level: {:atom, "${LOG_LEVEL}"}

# LOG_LEVEL=warn
iex(hello@127.0.0.1)3> Logger.warn "hello"
13:22:25.461 [warn]  hello
```

## Installation

All you need to do is copy a single file, add one line to release config
and adjust the prod configuration.

#### 1. Wrap config values in `{type, value}` tuples

```ex
# config/prod.exs
use Mix.Config

config :hello,
  str_var: "${STR_VAR}",
  int_var: {:integer, "${INT_VAR}"},
  bool_var: {:boolean, "${BOOL_VAR}"}
```

#### 2. Copy [`typonf.sh`](typonf.sh) into `rel/hooks/typonf.sh`

```bash
# this code snippet is here so you don't miss it
mkdir -p rel/hooks
vim rel/hooks/typonf.sh
```

#### 3. Set `post_configure_hook` in `rel/config.exs`

```ex
# rel/config.exs
environment :prod do
  # ...
  set post_configure_hook: "rel/hooks/typonf.sh"
end
```

#### 4. PROFIT

```bash
# build release
mix release

# see it working
STR_VAR=hi INT_VAR=123 BOOL_VAR=true REPLACE_OS_VARS=true _build/prod/rel/hello/bin/hello console
iex(hello@127.0.0.1)1> Application.get_env(:hello, :str_var)
"hi"
iex(hello@127.0.0.1)2> Application.get_env(:hello, :int_var)
123
iex(hello@127.0.0.1)3> Application.get_env(:hello, :bool_var)
true
```
