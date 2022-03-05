using Genie.Router
using Genie.Requests
using Vortex

route("/") do
  Vortex.draw_page(9, 2)
end

route("/", method = POST) do
  modulus = parse(Int64, postpayload(:modulus, "9"))
  multiplier = parse(Int64, postpayload(:multiplier, "2"))
  Vortex.draw_page(modulus, multiplier)
end