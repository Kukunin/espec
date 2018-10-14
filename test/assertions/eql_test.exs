defmodule EqlTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      it do: expect(1 + 1) |> to(eql(2))
      it do: expect(1 + 1) |> to_not(eql(2.0))
    end

    context "Errors" do
      it do: expect(1 + 1) |> to(eql(2.0))
      it do: expect(1 + 1) |> to_not(eql(2))
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples(), true)
    {:ok, success: Enum.slice(examples, 0, 1), errors: Enum.slice(examples, 2, 3)}
  end

  test "Success", context do
    Enum.each(context[:success], &assert(&1.status == :success))
  end

  test "Errors", context do
    Enum.each(context[:errors], &assert(&1.status == :failure))
  end
end
