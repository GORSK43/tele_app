defmodule TeleApp.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TeleApp.Catalog` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        title_short: "some title_short"
      })
      |> TeleApp.Catalog.create_category()

    category
  end

  @doc """
  Generate a unique product article.
  """
  def unique_product_article, do: "some article#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique product name.
  """
  def unique_product_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique product name_short.
  """
  def unique_product_name_short, do: "some name_short#{System.unique_integer([:positive])}"

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        article: unique_product_article(),
        description: "some description",
        name: unique_product_name(),
        name_short: unique_product_name_short(),
        price: "120.5",
        qty: 42,
        visible: true
      })
      |> TeleApp.Catalog.create_product()

    product
  end

  @doc """
  Generate a attribute.
  """
  def attribute_fixture(attrs \\ %{}) do
    {:ok, attribute} =
      attrs
      |> Enum.into(%{
        content: "some content",
        name: "some name"
      })
      |> TeleApp.Catalog.create_attribute()

    attribute
  end
end
