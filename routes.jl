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
  Drawing(600, 600, "public/vortex/vortex_$(modulus)_$(multiplier).svg")
  origin()
  setcolor("black")

  circle_radius = 250
  Luxor.circle(Point(0,0), circle_radius, :stroke)

  points = Vector{Point}()
  starting_angle = -π/2
  turning_angle = (2*π)/modulus

  # Draw points around the perimeter of the circle
  for n in 0:modulus-1
    point = Point(circle_radius*cos(starting_angle+n*turning_angle),circle_radius*sin(starting_angle+n*turning_angle))
    push!(points, point)
    Luxor.circle(point, 5, :fill)
  end

  # Label the points

  # Connect the points


  finish()
end

route("/") do
  html(get_form(9,2))
end

route("/", method = POST) do
  modulus = parse(Int64, postpayload(:modulus, "9"))
  multiplier = parse(Int64, postpayload(:multiplier, "2"))
  draw_vortex(modulus, multiplier)
  page = """
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Tesla Vortex</title>
    <link href="/css/image_scale.css" rel="stylesheet" />
  </head>
  <body>
    $(get_form(modulus, multiplier))
    <img src="vortex/vortex_$(modulus)_$(multiplier).svg">
  </body>
  </html>
  """
  html(page)
end