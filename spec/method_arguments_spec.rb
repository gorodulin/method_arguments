require "spec_helper"
require "method_arguments"

RSpec.describe MethodArguments do
  let(:test_class) do
    Class.new do
      attr_reader :one, :two, :three, :four, :five, :rest_keyword_args

      def with_writers(args)
        set_instance_vars(args, use_writers: true)
      end

      def without_writers(args)
        set_instance_vars(args, use_writers: false)
      end

      def auto_args(one, two = 2, three: 3, four: 4, **rest_keyword_args)
        set_instance_vars(__method_args__)
      end

      def one=(val)
        @one = "--#{val}--"
      end
    end
  end

  let(:obj) { test_class.new }

  describe "#set_instance_vars method" do
    context "when use_writers: false" do
      subject { obj.without_writers({one: 1, two: 2}) }
      it "assigns instance variables correctly" do
        subject
        expect(obj.instance_variable_get(:@one)).to eq(1)
        expect(obj.instance_variable_get(:@two)).to eq(2)
      end

      context "when use_writers: true" do
        subject { obj.with_writers({one: 1, two: 2}) }
        it "assigns instance variables correctly" do
          subject
          expect(obj.one).to eq("--1--")
          expect(obj.two).to eq(2)
        end
      end

      context "when first argument is not a Hash" do
        context "when Array" do
          it "raises ArgumentError" do
            expect { obj.without_writers([1, 2, 3]) }.to raise_error(NoMethodError)
          end
        end
        context "when NilClass" do
          it "raises ArgumentError" do
            expect { obj.without_writers(nil) }.to raise_error(NoMethodError)
          end
        end
      end

      it "raises an error when called on a class or module" do
        expect { test_class.set_instance_vars({}) }.to raise_error(RuntimeError)
      end
    end
  end

  describe "#__method_args__ method" do
    context "when using __method_args__" do
      subject { obj.auto_args(1, three: 33, four: 44, five: 55) }

      it "captures method arguments correctly, including those optional" do
        subject
        expect(obj.one).to eq(1)
        expect(obj.two).to eq(2)
        expect(obj.three).to eq(33)
        expect(obj.four).to eq(44)
      end

      it "ignores extra arguments" do
        subject
        expect(obj.five).to eq(nil)
        expect(obj.rest_keyword_args).to eq(nil)
      end

      context "when called outside method" do
        context "when called on an instance" do
          it "raises RuntimeError" do
            expect { test_class.new.__method_args__ }.to raise_error(RuntimeError)
          end
        end

        context "when called on a class or module" do
          it "raises RuntimeError" do
            expect { test_class.__method_args__ }.to raise_error(RuntimeError)
          end
        end

        context "when called inside a Proc" do
          it "raises RuntimeError" do
            expect { Proc.new { __method_args__ }.call }.to raise_error(RuntimeError)
          end
        end
      end
    end
  end
end
