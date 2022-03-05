module Vortex

using Genie.Renderer.Html
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

function transmod(number, mod)
    if number % mod == 0
        return mod
    end
    return number % mod
end

function draw_vortex(modulus, multiplier)
    if isfile("public/vortex/vortex_$(modulus)_$(multiplier).svg")
        return
    end

    @info "Rendering public/vortex/vortex_$(modulus)_$(multiplier).svg"

    Drawing(600, 600, "public/vortex/vortex_$(modulus)_$(multiplier).svg")
    origin()
    setcolor("black")

    circle_radius = 250
    Luxor.circle(Point(0, 0), circle_radius, :stroke)

    points = Vector{Point}()
    starting_angle = -π / 2
    turning_angle = (2 * π) / modulus

    # Draw points around the perimeter of the circle
    for n in 1:modulus
        point = Point(circle_radius * cos(starting_angle + n * turning_angle), circle_radius * sin(starting_angle + n * turning_angle))
        push!(points, point)
        Luxor.circle(point, 5, :fill)
    end

    # Label the points
    fontsize(16)
    fontface("Serif")
    text_radius = circle_radius + 25
    for n in 1:modulus
        point = Point(text_radius * cos(starting_angle + n * turning_angle), text_radius * sin(starting_angle + n * turning_angle))
        Luxor.text("$(n)", point, halign = :center)
    end

    # Connect the points
    found_numbers = Vector{Int64}()
    for start_number in 1:modulus
        number = start_number
        while true
            previous_number = number
            number = number * multiplier
            mod_number = transmod(number, modulus)
            @debug "number: $(number) mod_number:$(mod_number)"
            Luxor.line(points[transmod(previous_number, modulus)], points[mod_number], action = :stroke)
            push!(found_numbers, transmod(number, modulus))
            if mod_number ∈ found_numbers
                break
            end
        end
    end

    finish()
end

function draw_page(modulus, multiplier)
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
end