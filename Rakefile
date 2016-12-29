gem 'rdoc'
require 'rspec/core/rake_task'
require 'rdoc/task'

# core_tests = {
    # :browser_test => FileList[
        # "dsl/Browser/spec",
        # "common/SeleniumBrowser/spec"
    # ],
    # :services_test => FileList["dsl/Services/spec"],
    # :common_browser_utilities_test => FileList["dsl/CommonBrowserUtilities/spec"],
    # :common_snapshot_utilities_test => FileList["dsl/CommonSnapshotUtilities/spec"],
    # :common_component_test => FileList["dsl/CommonComponent/spec"]
# }

# base_tests = {
    # :base_test => [
        # "common/spec",
        # "common/Mail/spec",
        # "common/BrowserConsole/spec",
        # "common/Cookies/spec",
        # "common/KeyCodes/spec",
        # "common/ProxyManager/spec",
        # "common/BrowserMob/spec"
    # ]
# }

# tool_tests = {
    # :cia_test => FileList["CIA/spec"],
    :finder_finder_test => FileList["FinderFinder/spec"],
    # :utgenerator_test => FileList["UTGenerator/spec"]
# }

# mobile_tests = {
    # :native_app_test => FileList[
        # "dsl/NativeApp/spec",
        # "common/AppiumNativeApp/spec"
    # ]
# }

# file_tests = {
    # :validation_test => FileList["dsl/FileValidations/spec"]
# }

# sterling_tests = {
    # :oms_tests => FileList[
        # "dsl/Sterling/spec"
# ]
# }

dynamically sets up each hash key as a rake-able task, ie services_test, browser_test, etc
# local_variables.map {|x| eval(x.to_s) if eval(x.to_s).class.eql?(Hash)}.inject(:merge).each { |k,v|
    # RSpec::Core::RakeTask.new(k.to_sym) do |t|
        # t.pattern = v
        # t.rspec_opts = ['-fs']
        t.verbose = true
    # end
# }

dynamically sets up each hash as a rake-able task, ie, core_tests, base_tests, tool_tests, etc.
# local_variables.each { |x|
    # if eval(x.to_s).class.eql?(Hash)
        # task x.to_sym => eval(x.to_s).keys
    # end
# }

# desc "Run all the DSL tests"
# task :all_unit_tests => [:core_tests, :base_tests, :tool_tests, :mobile_tests, :file_tests, :sterling_tests]
# task :default => :all_unit_tests

##################################
RDocs

# RDoc::Task.new(:framework_docs) do |rd|
  # rd.main = "Web and Services Framework"
  # rd.title = "Web and Services Framework Doc"
  # rd.rdoc_dir = "../Doc/WebAndServicesFrameworkDoc"
  # rd.options << "--exclude" << %Q['.*_spec.rb']
  # rd.rdoc_files.include(
    # "common/src",
    # "common/SeleniumBrowser/src",
    # "common/Cookies/src",
    # "common/BrowserMob/src",
    # "common/ProxyManager/src",
    # "common/KeyCodes/src",
    # "common/Mail/src",
    # "dsl/CommonComponent/src",
    # "dsl/CommonBrowserUtilities/src",
    # "dsl/CommonSnapshotUtilities/src",
    # "dsl/Browser/src",
    # "dsl/Services/src",
    # "dsl/Sterling/src"
  # )
# end

# RDoc::Task.new(:mobile_docs) do |rd|
  # rd.main = "Mobile Framework"
  # rd.title = "Mobile Framework Doc"
  # rd.rdoc_dir = "../Doc/MobileFrameworkDoc"
  # rd.options << "--exclude" << %Q['.*_spec.rb']
  # rd.rdoc_files.include(
    # "common/AppiumNativeApp/src",
    # "dsl/NativeApp/src",
  # )
# end

# desc "Create all RDoc"
# task :all_docs => [:framework_docs, :mobile_docs]


