using Genie.Router
using Genie.Renderer.Html
using Genie.Requests
using Luxor

function get_form(modulus, multiplier)
  form = """
  <form action="/" method="POST" enctype="multipart/form-data">
    <label for="modulus">Modulus:</label>
    <input type="text" name="modulus" id="modulus" value="$(modulus)" placeholder="Modulus" />
    <label for="multiplier">Multiplier:</label>
    <input type="text" name="multiplier" id="multiplier" value="$(multiplier)" placeholder="Multiplier" />
    <input type="submit" value="Render" />
  </form>
  """
end

function draw_vortex(modulus, multiplier)
  Drawing(1200, 1200, "public/vortex/vortex_$(modulus)_$(multiplier).svg")
  origin()
  setcolor("red")
  Luxor.circle(Point(0,0), 500, :fill)
  finish()
end

route("/") do
  html(get_form(9,2))
end

route("/", method = POST) do
  modulus = postpayload(:modulus, "9")
  multiplier = postpayload(:multiplier, "2")
  draw_vortex(modulus, multiplier)
  html(get_form(modulus, multiplier) * "<img src=\"vortex/vortex_$(modulus)_$(multiplier).svg\">")
end