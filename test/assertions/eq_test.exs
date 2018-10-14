defmodule EqTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec

    context "Success" do
      ESpec.Context.describe "ESpec.Assertions.Eq" do
        it do: expect(1 + 1) |> to(eq(2.0))
        it do: expect(1 + 1) |> to_not(eq(3))
      end

      ESpec.Context.describe "be" do
        it do: expect(1 + 1 == 2) |> to(be true)
        it do: expect(1 + 1 == 1) |> to_not(be true)
        it do: expect(1 + 1 == 1) |> to(be false)
        it do: expect(nil) |> to(be nil)
        it do: expect(1 + 1) |> to(be 2)
      end
    end

    context "Errors" do
      ESpec.Context.describe "ESpec.Assertions.Eq" do
        it do: expect(1 + 1) |> to(eq(3.0))
        it do: expect(1 + 1) |> to_not(eq(2))
      end

      ESpec.Context.describe "be" do
        it do: expect(1 + 1 == 1) |> to(be true)
        it do: expect(1 + 1 == 1) |> to_not(be false)
      end
    end
  end

  setup_all do
    examples = ESpec.SuiteRunner.run_examples(SomeSpec.examples(), true)
    {:ok, success: Enum.slice(examples, 0, 6), errors: Enum.slice(examples, 7, 11)}
  end

  test "Success", context do
    Enum.each(context[:success], &assert(&1.status == :success))
  end

  test "Errors", context do
    Enum.each(context[:errors], &assert(&1.status == :failure))
  end
end
