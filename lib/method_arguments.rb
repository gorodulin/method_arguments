# frozen_string_literal: true

module MethodArguments
  module InstanceMethods

    def set_instance_vars(args, use_writers: false)
      raise "Call this method on instances only" if self.instance_of?(Class) || self.instance_of?(Module)

      args.each_pair do |name, value|
        if use_writers && respond_to?(writer = :"#{name}=", true)
          send(writer, value)
        else
          instance_variable_set("@#{name}", value)
        end
      end
    end

  end

  module BindingMethods
    # See https://bugs.ruby-lang.org/issues/18487
    define_method :__method_args__, ::Kernel::method(:binding) >> ->(bng) {
      caller_info = caller_locations(1,1)[0]
      caller_method_name = caller_info.base_label
      begin
        params = bng.receiver.method(caller_method_name).parameters.map do |type, varname|
          (type == :keyrest || type == :rest || type == :block) ? nil : varname
        end.compact
        params.map { |varname| [varname, bng.local_variable_get(varname)] }.to_h
      rescue NameError => err
        raise err unless err.message.start_with?("undefined method `<")
        raise RuntimeError, "__method_args__ called outside method", cause: nil
      end
    }
  end
end

Object.include MethodArguments::BindingMethods  unless Object.included_modules.include?(MethodArguments::BindingMethods)
Object.include MethodArguments::InstanceMethods unless Object.included_modules.include?(MethodArguments::InstanceMethods)
