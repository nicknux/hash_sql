require "hash_sql/version"

module HashSql
  # Creates a SQL Select Statement
  # @param [String] table The table name to select records from  
  # @param [Hash] options Additional options for the query
  # @option options [Array] fields An array of field names to return in the seach result 
  # @option options [Hash] filter 
  #   The filter to use for searching accounts. The key is the field name
  #   to set the filter on, and the value is the concatenation of the
  #   operator to use for comparison and the value used for comparing.
  #   Example: { email: "='test@abc.com'"}
  # 
  #   AND and ORs:
  #   The logical operations between filters can be AND or OR and 
  #   it could be set by setting the key to either "and:" or "or:"
  #   Example: { email: "='test@abc.com", and: {firstname: "='Nick'"} }
  #   Will be translated to email='test@abc.com' AND firstname = 'Nick'
  #   
  #   If multiple entries are placed inside an "and:" or "or:" they will
  #   "ANDed" or "ORed" together.
  #   Example: { email: "='test@abc.com", and: {firstname: "='Nick'", lastname: "='DS'"} }
  #   Will be translated to email='test@abc.com' AND (firstname = 'Nick' AND lastname = 'DS')
  #
  #   Example: { email: "='test@abc.com", or: {firstname: "='Nick'", lastname: "='DS'"} }
  #   Will be translated to email='test@abc.com' OR (firstname = 'Nick' OR lastname = 'DS')
  #
  #   NESTING
  #   Example: { email: "='test@abc.com", and: {firstname: "='Nick'", or: {lastname: "='DS'"}} }
  #   Will be translated to:
  #   email='test@abc.com' AND (firstname = 'Nick' OR lastname = 'DS') 
  # @option options [Hash] :order_by The order in which the results are returned. The key is the
  #   field to order on, and the value is :ASC or :DESC
  # @option options [Number] :limit the number of results to return
  # @return [Hash]
  #
  def self.select_statement(table, options={})
    fields = options[:fields]
    order_by = options[:order_by]
    limit = options[:limit]
    filter = options[:filter]
    query = "SELECT #{fields.join(',')} FROM #{table}"

    filter_string = " WHERE #{parse_filter(filter, nil, '')}" unless filter.nil?
    order_string = " ORDER BY #{parse_order_by(order_by)}" unless order_by.nil?
    limit_string = " LIMIT #{limit}" unless limit.nil?        
    
    filter_string ||= ''
    order_string ||= ''
    limit_string ||= ''

    query = query + filter_string + order_string + limit_string
  end

  private

  def self.parse_filter(filter={}, operator, filter_string)        
    filter.each_with_index do |(k, v), index|          
      if k == :and || k == :or
        filter_string += "#{k.to_s.upcase} " unless index == 0                 
        filter_string += '(' unless v.count == 1
        filter_string = parse_filter(v, k, filter_string)
        filter_string += ')' unless v.count == 1            
      else            
        filter_string += "#{k}#{v} "            
        if !operator.nil? && index < filter.count - 1 && filter.values[index + 1].class != Hash              
          filter_string += "#{operator.to_s.upcase} "
        end
      end
    end        
    filter_string.rstrip
  end

  def self.parse_order_by(order_by={})
    order_string = ''
    order_by.each_with_index do |(k,v), index|
      if v != :ASC || v != :DESC
        v = :ASC
      end
      order_string += "#{k} #{v.to_s.upcase}"
      order_string += ',' unless index == order_by.count - 1
    end

    order_string
  end  
end
