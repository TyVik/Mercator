-module(sql_driver).
-export([run_sql/1, decode_point/1]).

-define(host, "localhost").
-define(port, 5432).
-define(db, "mercator").
-define(user, "mercator").
-define(password, "mercator").

decode_point(P) ->
    L = binary_to_list(P),
    string:tokens(string:substr(L, 2, length(L) - 2), ",").

run_sql(Query) ->
    with_connection(
        fun(C) -> {ok, Cols, Rows} = pgsql:squery(C, Query) end
    ).

with_connection(F) ->
    with_connection(F, []).

with_connection(F, Args) ->
    Args2 = [{port, ?port}, {database, ?db} | Args],
    {ok, C} = pgsql:connect(?host, ?user, ?password, Args2),
    try
        F(C)
    after
        pgsql:close(C)
    end.
