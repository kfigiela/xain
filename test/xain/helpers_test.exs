defmodule Xain.HelpersTest do
  use ExUnit.Case
  import Xain.Case
  import Xain.Helpers


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

  test "ensure_valid_contents doesn't affect binaries and lists" do
    assert ensure_valid_contents("test") == "test"
    assert ensure_valid_contents('test') == 'test'
    assert ensure_valid_contents(["1", "2", "3"]) == ["1", "2", "3"]
  end

  @log_msg "the first argument supposed to be a binary"
  test "ensure_valid_contents calls to_string for numbers, booleans and atoms" do
    assert capture_log(fn ->
      assert ensure_valid_contents(:test) == "test"
    end) =~ @log_msg
    assert capture_log(fn ->
      assert ensure_valid_contents(1) == "1"
    end) =~ @log_msg
    assert capture_log(fn ->
      assert ensure_valid_contents(3.14) == "3.14"
    end) =~ @log_msg
    assert capture_log(fn ->
      assert ensure_valid_contents(nil) == ""
    end) =~ @log_msg
    assert capture_log(fn ->
      assert ensure_valid_contents(true) == "true"
    end) =~ @log_msg
  end

  test "ensure_valid_contents raises error if String.Chars is not implemented for the first argument" do
    assert capture_log(fn ->
      assert_raise Protocol.UndefinedError, "protocol String.Chars not implemented for %{}", fn ->
        ensure_valid_contents(%{})
      end
    end) =~ @log_msg
  end
end
