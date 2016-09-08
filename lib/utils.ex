defmodule Utils do
  defmacro __using__(_opts) do
    quote do
      import Utils
    end
  end

  defmacro if(condition, default, do: do_clause) do
    build_if(condition, do: do_clause, else: default)
  end

  defp build_if(condition, do: do_clause, else: else_clause) do
    optimize_boolean(quote do
      case unquote(condition) do
        x when x in [false, nil] -> unquote(else_clause)
        _ -> unquote(do_clause)
      end
    end)
  end

  defp optimize_boolean({:case, meta, args}) do
    {:case, [{:optimize_boolean, true} | meta], args}
  end


  defmacro setf(expr, value) do
    {keys, quoted_var} = parse_expr(expr, [], nil)
    quote do
      put_in(unquote(quoted_var), unquote(keys), unquote(value))
    end
  end

  defp parse_expr(nil, keys, quoted_var), do: {keys, quoted_var}
  defp parse_expr(expr, keys, _) do
    case expr do
      {{:., _, [Access, :get]}, _, [sub_expr, key]} ->
        parse_expr(sub_expr, [key | keys], nil)
      {{:., _, [sub_expr, key]}, _, _} ->
        parse_expr(sub_expr, [key | keys], nil)
      expr ->
        parse_expr(nil, keys, expr)
    end
  end
end
