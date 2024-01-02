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

## Feature

### Reading Method Arguments

Within any method, call `__method_args__` to retrieve its arguments as a Hash.

```ruby
  def initialize(user_entity, first_name:, last_name:, age:, **kw_rest)
    "Method ##{__method__} received #{__method_args__.inspect} arguments"
  end
```

***Note:**  The returned Hash excludes `*rest`, `**keyrest` and `&block` arguments regardless of their name.*

### Filling instance @variables

Use `set_instance_vars(hash)` to assign instance variables from a Hash.

### Filling instance @variables using attribute writers

To leverage setters ([attribute writers](https://docs.ruby-lang.org/en/3.1/Module.html#method-i-attr_writer)), add `use_writers: true` argument. If a writer with the corresponding name exists, it will be invoked.

<details>
  <summary>Example</summary>

  Before:

  ```ruby
  def initialize(user_entity, first_name:, last_name:, age:, ...)
    @user_entity = user_entity
    @first_name = first_name
    @last_name = last_name
    self.age = age
    ...
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

### Installation

1. Add to your Gemfile, then run `bundle install`:

    ```ruby
    gem "method_arguments"
    ```

2. Prepend your code with

    ```ruby
    require "method_arguments"
    ```


### Supported Ruby versions

Tested on MRI v2.7.2, v3.0.3, v3.1.2 (x86_64)

> Keywords: #ruby #args #arguments #attributes #attrs #p20220903a #method
