(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using TeslaVortex
push!(Base.modules_warned_for, Base.PkgId(TeslaVortex))
TeslaVortex.main()
