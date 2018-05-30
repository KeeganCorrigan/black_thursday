require_relative 'sales_engine'
require_relative 'customer'

class CustomerRepository
  attr_reader :customers

  def initialize(customers)
    @customers ||= create_customer(customers)
  end

  def create_customer(customers)
    customers.map do |row|
      Customer.new(row)
    end
  end

  def inspect
   "#<#{self.class} #{@invoice_items.size} rows>"
  end

  def all
    @customers
  end

  def find_by_id(id)
    @customers.find {|customer| customer.id == id}
  end

  def find_all_by_first_name(first_name)
    @customers.find_all {|customer| customer.first_name.downcase.include?(first_name.downcase)}
  end

  def find_all_by_last_name(last_name)
    @customers.find_all {|customer| customer.last_name.downcase.include?(last_name.downcase)}
  end

  def generate_id_for_new_customer
    (@customers.max_by { |customer| customer.id }).id + 1
  end

  def create(attributes)
    attributes[:id] = generate_id_for_new_customer
    @customers << Customer.new(attributes)
  end
end
