defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)

  end

  def save_image(img_file, img_name) do
    File.write("#{img_name}.png", img_file)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({ _value, index }) ->
      horizontal = rem(index, 5 ) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      botoom_right = {horizontal + 50, vertical + 50}

      {top_left, botoom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map})do 
    image = :egd.create(250,250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start,stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end
    :egd.render(image)
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image)do
    grid = Enum.filter grid, fn({value, _index}) -> 
      # if is divided by two
      rem(value,2) == 0 
    end

    %Identicon.Image{image | grid: grid}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | tail]} = image_struct) do
    #r,g,b | tail] = hex_list #picking the first three elements in the list
    %Identicon.Image{image_struct | color: {r, g, b}}
  end

  def mirrors(row)do
    [first, second | _tail] = row
    row ++ [second, first]
   
  end


  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk(3)
    #passing a reference to a function
    |> Enum.map(&mirrors/1)
    #making one single list with all items
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image{image | grid: grid}

  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list 
    %Identicon.Image{hex: hex}
  end
end
