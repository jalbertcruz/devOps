defmodule Types do

  defprotocol JWTGenerator do

    @spec init(t, t) :: any
    def init(this, opts)

    @spec encode_and_sign(t, t) :: String.t()
    def encode_and_sign(this, claims)

  end


  defprotocol JWTVerifier do

    @spec init(t, t) :: any
    def init(this, opts)

    @spec decode_and_verify(t, String.t()) :: {:ok, map()} | {:error, String.t()}
    def decode_and_verify(this, token)

  end


end
