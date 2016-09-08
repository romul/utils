# Utils

Provide some handy functions for Elixir, for example:

With `if/3` you could pass default value returned from if-expression instead of silly else clause

```elixir
  map = if map[:b], map do
    Map.delete(map, :b)
  end

  # instead of

  map = if map[:b] do
    Map.delete(map, :b)
  else
    map
  end
```

With `setf/2` you could set value deep-nested inside a map or a struct in a natural way

```elixir
  map = %{a: %{b: %{c: 5}}}
  map = setf(map.a.b.c, 7)

  # instead of

  map = %{a: %{b: %{c: 5}}}
  map = put_in(map, [:a, :b, :c], 7)
```

## Installation

Add `utils` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:utils, "~> 0.1.0"}]
    end
    ```
