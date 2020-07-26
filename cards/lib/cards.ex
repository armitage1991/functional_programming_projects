defmodule Cards do

  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  #using erlang features



  def read_file(file_name) do
    # case statements
    case File.read(file_name) do
      {:ok, binary} -> :erlang.binary_to_term binary
      {:error, _reason} -> "That file does not exist"
      
    end
  end


  @doc """
    save the deck created into file system
  """
  def save_deck(deck, file_name) do
    binary = :erlang.term_to_binary(deck)
    File.write(file_name, binary)
  end

  @doc """
    function to create a deck of cards
  """
  def create_deck do
    #Building a list of decks 
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]


    for suit <- suits, value <- values do 
      "#{value} of #{suit}"
    end
  end

  @doc """
    function to suffle a deck of cards
  """
  def shuffle(deck) do
    Enum.shuffle(deck)
  end


  @doc """
    verify if a specific deck contains a card

    ## Examples
       iex> deck = Cards.create_deck
       iex> Cards.contains?(deck,"Ace of Spades")
       true


  """
  def contains?(deck, card) do
    Enum.member?(deck,card)
  end


  @doc """
    Divides a deck into a hand and the reminder of the deck
    the hand_size indicate how many cards should be in the hand
  """
  def deal(deck,hand_size) do
    {head, deck} = Enum.split(deck, hand_size)
    
  end

  def create_hand(hand_size) do
    create_deck
      |> shuffle
      |> deal hand_size
      
  end

end
