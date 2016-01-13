-module(shackle_profile).

-export([
    fprof/0
]).

%% public
-spec fprof() -> ok.

fprof() ->
    application:start(shackle),
    arithmetic_tcp_client:start(),
    [20 = arithmetic_tcp_client:add(10, 10) || _ <- lists:seq(1,10)],

    timer:sleep(1000),

    fprof:start(),
    {ok, Tracer} = fprof:profile(start),
    fprof:trace([start, {cpu_time, false}, {procs, all}, {tracer, Tracer}]),

    spawn(fun () -> 20 = arithmetic_tcp_client:add(10, 10) end),

    fprof:trace(stop),
    fprof:analyse([totals, {dest, ""}]),
    fprof:stop(),

    ok.

