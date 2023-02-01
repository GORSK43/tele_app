defmodule TeleAppWeb.ProductHTML do
  use TeleAppWeb, :html
# import Phoenix.HTML.Form, [:select, :form_for/2]
  

  def select_category(f) do 
    all_categories = TeleApp.Catalog.list_categories()
    data = Enum.map(all_categories, & [key: &1.title, value: &1.id])
    Phoenix.HTML.Form.select(f, :category_id, data, class: "mx-4")
  end

  embed_templates "product_html/*"
end
