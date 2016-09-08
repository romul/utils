defmodule UtilsTest do
  use ExUnit.Case
  use Utils
  doctest Utils

  test "Utils.if/3 when condition is false" do
    map = %{a: 5}
    map = if map[:b], map do
      Map.delete(map, :b)
    end
    assert map == %{a: 5}
  end

  test "Utils.if/3 when condition is true" do
    map = %{a: 5, b: 7}
    map = if map[:b], map do
      Map.delete(map, :b)
    end
    assert map == %{a: 5}
  end

  test "setf with [] syntax" do
    map = %{a: %{b: %{c: 5}}}
    assert setf(map[:a][:b][:c], 7) == %{a: %{b: %{c: 7}}}
  end

  test "setf with . syntax" do
    map = %{a: %{b: %{c: 5}}}
    assert setf(map.a.b.c, 7) == %{a: %{b: %{c: 7}}}
  end
end
