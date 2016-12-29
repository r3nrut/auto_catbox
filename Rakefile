gem 'rdoc'
require 'rdoc/task'

#dynamically sets up each hash key as a rake-able task, ie services_test, browser_test, etc
# local_variables.map {|x| eval(x.to_s) if eval(x.to_s).class.eql?(Hash)}.inject(:merge).each { |k,v|
    # RSpec::Core::RakeTask.new(k.to_sym) do |t|
        # t.pattern = v
        # t.rspec_opts = ['-fs']
        #t.verbose = true
    # end
# }

#dynamically sets up each hash as a rake-able task, ie, core_tests, base_tests, tool_tests, etc.
# local_variables.each { |x|
    # if eval(x.to_s).class.eql?(Hash)
        # task x.to_sym => eval(x.to_s).keys
    # end
# }


##################################
#RDocs

# desc "Create all RDoc"
# task :all_docs => [:framework_docs, :mobile_docs]


