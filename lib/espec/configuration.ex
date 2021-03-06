defmodule ESpec.Configuration do
  @moduledoc """
  Handles ESpec configurations.
  @list contains all available keys in config.
  """
  @list [
    hello: "Description",
    before: "Defines before hook",
    finally: "Defines finally hook",
    silent: "No output",
    file_opts: "Run the specific file or spec in the file",
    formatters: "Specifies formatters list",
    trace: "Detailed output",
    out_file: "Output file",
    focus: "Run only examples with [focus: true]",
    order: "Run specs in the order in which they are declared",
    sync: "Ignore async tag and run all specs synchronously",
    only: "Run only tests that match the filter",
    exclude: "Exclude tests that match the filter",
    string: "Run only examples whose full nested descriptions contain string",
    seed: "Seeds the random number generator used to randomize tests order",
    test: "For test purpose",
    shared_specs: "The shared spec files to include",
    start_loading_time: "Starts loading files",
    finish_loading_time: "Finished loading",
    finish_specs_time: "Finished specs",
    formatters_timeout:
      "How long to wait for the formatters to " <>
        "finish formatting (defaults to the GenServer call timeout)"
  ]

  @doc """
  Accepts a keyword of options.
  Puts options into application environment.
  Allows only whitelisted options.
  """
  def add(opts) do
    opts
    |> Enum.each(fn {key, val} ->
      if Enum.member?(Keyword.keys(@list), key) do
        Application.put_env(:espec, key, val)
      end
    end)
  end

  @doc "Returns the value associated with key."
  def get(key), do: Application.get_env(:espec, key)

  @doc "Returns all options."
  def all, do: Application.get_all_env(:espec)

  @doc """
  Allows to set the config options.
  See `ESpec.configure/1`.
  """
  def configure(func), do: func.(ESpec.Configuration)

  Keyword.keys(@list)
  |> Enum.each(fn func ->
    def unquote(func)(value) do
      ESpec.Configuration.add([{unquote(func), value}])
    end
  end)
end
