using Profile

include(ARGS[1])
@profile include(ARGS[1])
Profile.print(IOContext(open("/tmp/julprof.data", "w"), :displaysize=>(100000,1000)), format=:flat);
run(`/home/oleete/.config/bin/nvrWS "lua _G.jul_perf_flat()"`);
