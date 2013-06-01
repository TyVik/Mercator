-module(geo).
-export([polygon/1, parsePolygonsAndAnswers/1]).

% delete escaping symbol
unquote([]) -> [];
unquote([92|[92|[92|[92|T]]]]) -> [92, unquote(T)]; % why???
unquote([92|[H|T]]) -> [H, unquote(T)];
unquote([H|T]) -> [H,  unquote(T)].

polygon([]) -> "";
polygon(Raw) ->
    K = binary_to_list(Raw),
    L = string:substr(K, 3, length(K) - 4), % уберём кавычки postgres
    unquote(L).

answer([]) -> "";
answer(Raw) ->
    K = binary_to_list(Raw),
    L = string:substr(K, 2, length(K) - 2),
    [Point1Lat|[Point1Lon|[Point2Lat|[Point2Lon]]]] = string:tokens(L, ","),
    "new google.maps.LatLngBounds(new google.maps.LatLng(" ++ Point1Lat ++ ", " ++ Point1Lon ++ "), new google.maps.LatLng(" ++ Point2Lat ++ "," ++ Point2Lon ++ "))".

parsePolygons([]) -> [];
parsePolygons([{Row}|T]) -> polygon(Row) ++ ", " ++ parsePolygons(T).

parsePolygonsAndAnswers([]) -> {"", ""};
parsePolygonsAndAnswers([Country|T]) ->
    {Row, Answer} = Country,
    {TailPolygon, TailAnswer} = parsePolygonsAndAnswers(T),
    {polygon(Row) ++ ", " ++ TailPolygon, answer(Answer) ++ ", " ++ TailAnswer}.
