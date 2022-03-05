using Genie.Router
using Genie.Renderer.Html
using Genie.Requests

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

route("/") do
  html(get_form(9,2))
end

route("/", method = POST) do
  modulus = postpayload(:modulus, "9")
  multiplier = postpayload(:multiplier, "2")
  html(get_form(modulus, multiplier) * "Modulus: $(modulus) Multiplier: $(multiplier)")
end