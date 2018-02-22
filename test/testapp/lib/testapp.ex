defmodule Testapp do
  def test do
    :warn = Logger.level
    "hi" = Application.get_env(:testapp, :str_var)
    123 = Application.get_env(:testapp, :int_var)
    true = Application.get_env(:testapp, :bool_var)
  end
end
