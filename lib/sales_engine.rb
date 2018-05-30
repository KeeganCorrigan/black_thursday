require_relative 'csv_parser'
require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'sales_analyst'
require_relative 'transaction_repository'
require_relative 'customer_repository'

class SalesEngine
  attr_reader :file_path,
              :items,
              :merchants,
              :invoices,
              :invoice_items,
              :transactions,
              :customers

  def initialize(file_path = nil)
    @csv_parser = CsvParser.new
    @file_path = file_path
  end

  def analyst
    SalesAnalyst.new(merchants, items, invoices, invoice_items, transactions)
  end

  def self.from_csv(file_path)
    SalesEngine.new(file_path)
  end

  def merchants
    @merchants ||= MerchantRepository.new(@csv_parser.load_csv(file_path[:merchants]))
  end

  def items
    @items ||= ItemRepository.new(@csv_parser.load_csv(file_path[:items]))
  end

  def invoices
    @invoices ||= InvoiceRepository.new(@csv_parser.load_csv(file_path[:invoices]))
  end

  def invoice_items
    @invoice_items ||= InvoiceItemRepository.new(@csv_parser.load_csv(file_path[:invoice_items]))
  end

  def transactions
    @transactions ||= TransactionRepository.new(@csv_parser.load_csv(file_path[:transactions]))
  end

  def customers
    @customers ||= CustomerRepository.new(@csv_parser.load_csv(file_path[:customers]))
  end
end
