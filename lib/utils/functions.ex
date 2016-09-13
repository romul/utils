defmodule Utils.Functions do
  def compose(funs) do
    arity = :erlang.fun_info(hd(funs))[:arity]
    fn(args) ->
      Enum.reduce(funs, args, fn(fun, res) ->
        if is_list(res) do
          apply(fun, res)
        else
          apply(fun, [res])
        end
      end)
    end |> transform_function(arity)
  end

  def disjoin(funs) do
    arities = funs
    |> Enum.map(fn(fun) -> :erlang.fun_info(fun)[:arity] end)
    |> Enum.uniq

    arity = case arities do
      [arity] -> arity
      _ -> raise ArgumentError.exception("Utils.disjoin/1 allows only funs with the same arity")
    end

    fn(args) ->
      Enum.any?(funs, fn(fun) ->
        apply(fun, args)
      end)
    end |> transform_function(arity)
  end

  def conjoin(funs) do
    arities = funs
    |> Enum.map(fn(fun) -> :erlang.fun_info(fun)[:arity] end)
    |> Enum.uniq

    arity = case arities do
      [arity] -> arity
      _ -> raise ArgumentError.exception("Utils.conjoin/1 allows only funs with the same arity")
    end

    fn(args) ->
      Enum.all?(funs, fn(fun) ->
        apply(fun, args)
      end)
    end |> transform_function(arity)
  end

  def carry(fun, arg) do
    new_arity = :erlang.fun_info(fun)[:arity] - 1
    fn(args) ->
      apply(fun, [arg | args])
    end |> transform_function(new_arity)
  end

  def rcarry(fun, arg) do
    new_arity = :erlang.fun_info(fun)[:arity] - 1
    fn(args) ->
      apply(fun, args ++ [arg])
    end |> transform_function(new_arity)
  end

  def transform_function(fun, arity) do
    case arity do
      0 -> fn() -> fun.([]) end
      1 -> fn(a) -> fun.([a]) end
      2 -> fn(a, b) -> fun.([a, b]) end
      3 -> fn(a, b, c) -> fun.([a, b, c]) end
      4 -> fn(a, b, c, d) -> fun.([a, b, c, d]) end
      5 -> fn(a, b, c, d, e) -> fun.([a, b, c, d, e]) end
      6 -> fn(a, b, c, d, e, f) -> fun.([a, b, c, d, e, f]) end
      7 -> fn(a, b, c, d, e, f, g) -> fun.([a, b, c, d, e, f, g]) end
    end
  end
end
