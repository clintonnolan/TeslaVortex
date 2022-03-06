using Genie.Router
using Genie.Requests
using Genie.Renderer.Html
using Vortex

integer_regex = r"^\d+$"

error_page = """
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Tesla Vortex</title>
  </head>
  <body>
    <% error_message %>
  </body>
  </html>
"""

function draw_page_or_error()
  modulus_input = postpayload(:modulus, "9")
  modifier_input = postpayload(:multiplier, "2")
  error_messages = ""
  if match(integer_regex, modulus_input) === nothing
    error_messages *= " Modulus is not an integer"
  end
  if match(integer_regex, modifier_input) === nothing
    error_messages *= " Modifier must be an integer"
  end
  if error_messages != ""
    return html(error_messages)
  end

  modulus = parse(Int64, modulus_input)
  multiplier = parse(Int64, modifier_input)
  if modulus < 1
    error_messages *= " Modulus must be > 0"
  end
  if multiplier < 1
    error_messages *= " Multiplier must be > 0"
  end
  if error_messages != ""
    return html(error_messages)
  end
  Vortex.draw_page(modulus, multiplier)
end

route("/") do
  Vortex.draw_page(9, 2)
end

route("/", method = POST) do
  draw_page_or_error()
end