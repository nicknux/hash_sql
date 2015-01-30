require 'spec_helper'

RSpec.describe HashSql do
  describe '#query_basic' do
    it 'returns a query statement using a simple filter' do
      query = HashSql.select_statement(:accounts,
        fields: ['UID', 'profile.firstName', 'profile.lastName', 'profile.email'],
        filter: {
          "profile.email" => "='test05@mailinator.com'", 
          and: { "profile.firstName" => "='Five'", "profile.lastName" => "='Zero'" }
        }
      )
      expect(query).to eq("SELECT UID,profile.firstName,profile.lastName,profile.email FROM accounts WHERE profile.email='test05@mailinator.com' AND (profile.firstName='Five' AND profile.lastName='Zero')")
    end
  end

  describe '#query_nested' do
    it 'returns a query statement using nested filters' do
      query = HashSql.select_statement(:accounts,
        fields: ['UID', 'profile.firstName', 'profile.lastName', 'profile.email'],
        filter: {
          "profile.email" => "='test05@mailinator.com'", 
          and: { "profile.firstName" => "='Five'", or: { "profile.lastName" => "='Zero'", and: { "isActive" => "=true" } } }
        }
      )
      expect(query).to eq("SELECT UID,profile.firstName,profile.lastName,profile.email FROM accounts WHERE profile.email='test05@mailinator.com' AND (profile.firstName='Five' OR (profile.lastName='Zero' AND isActive=true))")
    end
  end  
end