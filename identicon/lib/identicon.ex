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
