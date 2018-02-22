script="$(dirname $0)/hooks/typonf.escript"
cat > $script <<EOF
#!/usr/bin/env escript
main([File]) ->
  {ok, [In]} = file:consult(File),
  file:write_file(File, io_lib:format("~tp.~n", [replace(In)])).

replace({Key, {atom, Bin}}) -> {Key, binary_to_atom(Bin, utf8)};
replace({Key, {integer, Bin}}) -> {Key, list_to_integer(binary_to_list(Bin))};
replace({Key, {boolean, <<"true">>}}) -> {Key, true};
replace({Key, {boolean, <<"false">>}}) -> {Key, false};
replace({Key, Bin}) when is_binary(Bin) -> {Key, Bin};
replace({Key, Atom}) when is_atom(Atom) -> {Key, Atom};
replace({Key, List}) when is_list(List) -> {Key, replace(List)};
replace([]) -> [];
replace([H|T]) -> [replace(H)|replace(T)].
EOF
chmod +x $script
$script $DEST_SYS_CONFIG_PATH
