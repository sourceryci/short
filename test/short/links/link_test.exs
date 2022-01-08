defmodule Short.Links.LinkTest do
  use Short.DataCase

  alias Short.Links.Link

  @valid_attributes %{
    url: "https://example.com",
    hash: "abcdefg"
  }

  describe "changeset" do
    test "with a valid attributes, it is valid" do
      changeset = Link.changeset(%Link{}, @valid_attributes)

      assert changeset.valid?
    end

    test "when the url attribute is not set, it is invalid" do
      changeset = Link.changeset(%Link{}, %{hash: "abcdef"})

      refute changeset.valid?
    end

    test "when the url format is invalid, it is invalid" do
      changeset = Link.changeset(%Link{}, %{@valid_attributes | url: "ftp://example.com"})

      refute changeset.valid?
    end

    test "when the hash attribute is not set, it is invalid" do
      changeset = Link.changeset(%Link{}, %{url: "https://example.com"})

      refute changeset.valid?
    end

    test "when the url is blank, it is valid" do
      changeset = Link.changeset(%Link{}, %{@valid_attributes | url: ""})

      refute changeset.valid?
    end

    test "when the hash is blank, it is valid" do
      changeset = Link.changeset(%Link{}, %{@valid_attributes | hash: ""})

      refute changeset.valid?
    end
  end
end
