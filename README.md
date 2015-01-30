# HashSql

Create SQL statements using Hashes. 
*(Currently only supports SELECT statements.)*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hash_sql'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_sql

## Usage

```ruby
# Basic query
# Will produce:
#   SELECT UID,profile.firstName,profile.lastName,profile.email 
#   FROM accounts 
#   WHERE profile.email='test05@mailinator.com' 
#      AND (profile.firstName='Five' AND profile.lastName='Zero')
#
query = HashSql.select_statement(:accounts,
    fields: ['UID', 'profile.firstName', 'profile.lastName', 'profile.email'],
    filter: {
      "profile.email" => "='test05@mailinator.com'", 
      and: { "profile.firstName" => "='Five'", "profile.lastName" => "='Zero'" }
    }
)

# Nested conditions
# Will produce:
#   SELECT UID,profile.firstName,profile.lastName,profile.email 
#    FROM accounts 
#    WHERE profile.email='test05@mailinator.com' 
#      AND (profile.firstName='Five' 
#        OR (profile.lastName='Zero' AND isActive=true))
#
query = HashSql.select_statement(:accounts,
    fields: ['UID', 'profile.firstName', 'profile.lastName', 'profile.email'],
    filter: {
      "profile.email" => "='test05@mailinator.com'", 
      and: { "profile.firstName" => "='Five'", or: { "profile.lastName" => "='Zero'", and: { "isActive" => "=true" } } }
    }
)
```

## Filter Hash

### Comparison
The filter to use for searching accounts. The key is the field name
to set the filter on, and the value is the concatenation of the
operator to use for comparison and the value used for comparing.
Example: 
```ruby
{ email: "='test@abc.com'"}
```

### AND and ORs:
The logical operations between filters can be AND or OR and the 
it could be set by setting the key to either "and:" or "or:"
Example: 
```ruby
{ email: "='test@abc.com", and: {firstname: "='Nick'"} }
```
Will be translated to: ```email='test@abc.com' AND firstname = 'Nick'```

If multiple entries are placed inside an "and:" or "or:" they will
"ANDed" or "ORed" together.
Example: 
```ruby
{ email: "='test@abc.com", and: {firstname: "='Nick'", lastname: "='DS'"} }
```
Will be translated to ```email='test@abc.com' AND (firstname = 'Nick' AND lastname = 'DS')```

Example: 
```ruby
{ email: "='test@abc.com", or: {firstname: "='Nick'", lastname: "='DS'"} }
```
Will be translated to ```email='test@abc.com' OR (firstname = 'Nick' OR lastname = 'DS')```

### NESTING
Example: 
```ruby
{ email: "='test@abc.com", and: {firstname: "='Nick'", or: {lastname: "='DS'"}} }
```
Will be translated to ```email='test@abc.com' AND (firstname = 'Nick' OR lastname = 'DS') ```

## Contributing

1. Fork it ( https://github.com/nicknux/hash_sql/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
