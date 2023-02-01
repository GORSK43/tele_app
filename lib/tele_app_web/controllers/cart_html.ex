defmodule TeleAppWeb.CartHTML do 
  use TeleAppWeb, :html 
  import Phoenix.HTML.Form, [:submit, :form_for/2]
  alias TeleApp.ShoppingCart

  def currency_to_str(%Decimal{} = val), do: "#{Decimal.round(val, 2)} руб"

  embed_templates "cart_html/*"
end
