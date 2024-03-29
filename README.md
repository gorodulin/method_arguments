# method_arguments gem

With the [method_arguments](https://github.com/gorodulin/method_arguments?tab=readme-ov-file#method_arguments-gem) gem you can easily set object attributes from method arguments.

Transform this:

```ruby
  def initialize(user_entity, first_name:, last_name:, email:, phone:, dob:)
    @user_entity = user_entity
    @first_name = first_name
    @last_name = last_name
    @email = email
    @phone = phone
    @dob = dob
  end
```

into this streamlined version:

```ruby
  def initialize(user_entity, first_name:, last_name:, email:, phone:, dob:)
    set_instance_vars(__method_args__)
  end
```

## Features

### 1. Reading Method Arguments

Within any method, call `__method_args__` to retrieve its arguments as a Hash.

```ruby
  def initialize(user_entity, first_name:, last_name:, age:, **kw_rest)
    "Method ##{__method__} received #{__method_args__.inspect} arguments"
  end
```

<details>
  <summary>Limitations</summary>
  <br>
  
  1. Argument types `*rest` and `**keyrest` are ignored regardless of their name:
     
      ```ruby
      def initialize(arg, *arg_rest, kw_arg:, **kw_rest)
        __method_args__ # returns { a: <value>, kw_arg: <value> }
      end
      ```
      
      Casting unknown arbitrary arguments to instance variables is not recommended for security reasons.
      
  2. The method does not support [argument forwarding](https://docs.ruby-lang.org/en/3.2/syntax/methods_rdoc.html#label-Argument+Forwarding):

      ```ruby
      def self.call(...)
        new(__method_args__).call # raises error
      end
      ```
  
</details>

### 2. Filling instance @variables

Use `set_instance_vars(hash)` to assign instance variables from a Hash.

### 3. Filling instance @variables using attribute writers

To leverage setters ([attribute writers](https://docs.ruby-lang.org/en/3.1/Module.html#method-i-attr_writer)), add `use_writers: true` argument. If a writer with the corresponding name exists, it will be invoked.

<details>
  <summary>Example</summary>
  <br>
  
  Before:

  ```ruby
  def initialize(user_entity, first_name:, last_name:, age:)
    @user_entity = user_entity
    @first_name = first_name
    @last_name = last_name
    self.age = age
  end

  def age=(val)
    @age = Integer(val)
  end
  ```

  After:

  ```ruby
  def initialize(user_entity, first_name:, last_name:, age:, ...)
    set_instance_vars(__method_args__, use_writers: true)
  end

  def age=(val)
    @age = Integer(val)
  end
  ```
</details>

## Installation

1. Add to your Gemfile, then run `bundle install`:

    ```ruby
    gem "method_arguments"
    ```

2. Prepend your code with

    ```ruby
    require "method_arguments"
    ```


## Supported Ruby Versions

This gem is designed to be compatible with Ruby 2.7 and above. It has been tested on the following MRI versions:

- v2.7.2
- v3.0.3
- v3.1.2

If you encounter any issues with later versions, please feel free to report them.

