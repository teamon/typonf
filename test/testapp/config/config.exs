use Mix.Config

config :logger,
  level: :debug

config :testapp,
  str_var: "hello",
  int_var: 123,
  bool_var: true

if Mix.env == :prod do
  config :logger,
    level: {:atom, "${LOG_LEVEL}"}

  config :testapp,
    str_var: "${STR_VAR}",
    int_var: {:integer, "${INT_VAR}"},
    bool_var: {:boolean, "${BOOL_VAR}"}
end
