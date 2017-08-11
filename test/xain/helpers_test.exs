defmodule Xain.HelpersTest do
  use ExUnit.Case
  import Xain.Helpers
  alias Phoenix.HTML, as: P

  test "id_and_class_shortcuts empty contents and attrs" do
    assert id_and_class_shortcuts("", []) == {"", []}
  end

  test "id_and_class_shortcuts empty contents and some attrs" do
    attrs = [class: "cls"]
    assert id_and_class_shortcuts("", attrs) == {"", attrs}
  end

  test "id_and_class_shortcuts some contents and some attrs" do
    attrs = [class: "cls"]
    assert id_and_class_shortcuts("test", attrs) == {"test", attrs}
  end

  test "id_and_class_shortcuts #id" do
    assert id_and_class_shortcuts("#test", []) == {"", [id: "test"]}
  end

  test "id_and_class_shortcuts doesn't broke multilines" do
    str = """
      line1
      line2
      line3
    """
    assert id_and_class_shortcuts(str, []) == {str, []}
  end

  test "ensure_valid_contents makes binaries and lists safe" do
    assert ensure_valid_contents("test") |> P.safe_to_string() == "test"
    assert ensure_valid_contents('test') |> P.safe_to_string() == "test"
    assert ensure_valid_contents(["1", "2", "3"]) |> P.safe_to_string() == "123"
  end

  test "ensure_valid_contents calls to_string for numbers, booleans and atoms" do
    assert ensure_valid_contents(nil)   |> P.safe_to_string() == ""
    assert ensure_valid_contents(:test) |> P.safe_to_string() == "test"
    assert ensure_valid_contents(1)     |> P.safe_to_string() == "1"
    assert ensure_valid_contents(3.14)  |> P.safe_to_string() == "3.14"
    assert ensure_valid_contents(true)  |> P.safe_to_string() == "true"
  end

  test "ensure_valid_contents raises error if String.Chars is not implemented for the first argument" do
    assert_raise Protocol.UndefinedError, ~r"protocol String\.Chars not implemented for %{}",
      fn -> ensure_valid_contents(%{}) end
  end
end
