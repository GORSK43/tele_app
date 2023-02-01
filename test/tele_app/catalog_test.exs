defmodule TeleApp.CatalogTest do
  use TeleApp.DataCase

  alias TeleApp.Catalog

  describe "categories" do
    alias TeleApp.Catalog.Category

    import TeleApp.CatalogFixtures

    @invalid_attrs %{description: nil, title: nil, title_short: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Catalog.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Catalog.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{description: "some description", title: "some title", title_short: "some title_short"}

      assert {:ok, %Category{} = category} = Catalog.create_category(valid_attrs)
      assert category.description == "some description"
      assert category.title == "some title"
      assert category.title_short == "some title_short"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", title_short: "some updated title_short"}

      assert {:ok, %Category{} = category} = Catalog.update_category(category, update_attrs)
      assert category.description == "some updated description"
      assert category.title == "some updated title"
      assert category.title_short == "some updated title_short"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_category(category, @invalid_attrs)
      assert category == Catalog.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Catalog.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Catalog.change_category(category)
    end
  end

  describe "products" do
    alias TeleApp.Catalog.Product

    import TeleApp.CatalogFixtures

    @invalid_attrs %{article: nil, description: nil, name: nil, name_short: nil, price: nil, qty: nil, visible: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Catalog.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{article: "some article", description: "some description", name: "some name", name_short: "some name_short", price: "120.5", qty: 42, visible: true}

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.article == "some article"
      assert product.description == "some description"
      assert product.name == "some name"
      assert product.name_short == "some name_short"
      assert product.price == Decimal.new("120.5")
      assert product.qty == 42
      assert product.visible == true
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{article: "some updated article", description: "some updated description", name: "some updated name", name_short: "some updated name_short", price: "456.7", qty: 43, visible: false}

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.article == "some updated article"
      assert product.description == "some updated description"
      assert product.name == "some updated name"
      assert product.name_short == "some updated name_short"
      assert product.price == Decimal.new("456.7")
      assert product.qty == 43
      assert product.visible == false
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end
end
