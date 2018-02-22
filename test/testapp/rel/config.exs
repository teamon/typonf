use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"secret"
  set post_configure_hook: "rel/hooks/typonf.sh"
end

release :testapp do
  set version: current_version(:testapp)
  set applications: [
    :runtime_tools
  ]
end
