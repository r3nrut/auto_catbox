class Payments

  include Enumerable
  include com.snaplogic.scripting.language.ScriptHook

  attr_reader :log, :input, :output, :error

  def initialize(log, input, output, error)
    @log = log
    @input = input
    @output = output
    @error = error
  end

  def execute(file_name)
    record_array, invoice_array = read_file(file_name)
    pay_enum, inv_enum = param_enums(record_array, invoice_array)
    group_records(pay_enum, inv_enum)
  end

  def read_file
    record_array = []
    invoice_array = []

    file_ar = IO.readlines(filename)

    file_ar.each_with_index do |r|
      record_array.push r.split('\n') if r =~ /^(6)\d(..*)/
      invoice_array.push r.split('\n') if r =~ /^(7)\d(..*)/
    end
    return record_array, invoice_array
  end

  def param_enums(payments, invoices)
    pay_enum = payments.each
    inv_enum = invoices.each_with_index
    #puts invoices.find_all{|i| puts i}
    return pay_enum, inv_enum
  end

  def group_records(pay_enum, inv_enum)
    #would need dynamic creation of array objects for each enumerable
    #method missing would be the best approach
    loop do
      @pay_a1,@inv_a2,@inv_a3=pay_enum.next,inv_enum.next,inv_enum.next
    end
    return puts "array 1 #{@pay_a1} \n array 2 #{@inv_a2} \n array 3 #{@inv_a3}"
  end

  def self.method_missing(enum, *args)
    #TBD
    # Dynamically create the arrays based on the enum object.  Need to count the index on inv_enum to iterate appropriately.
  end

end

# The Script Snap will look for a ScriptHook object in the "hook"
# variable.  The snap will then call the hook's "execute" method.
$hook = Payments.new($log, $input, $output, $error)
