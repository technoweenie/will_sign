require 'rubygems'
begin
  gem 'rspec'
rescue Gem::LoadError
end

$:.unshift File.dirname(__FILE__) + '/../../rspec/lib/'
$:.unshift File.dirname(__FILE__) + '/../lib'

require 'ruby-debug'
require 'spec'
require 'will_sign'

Debugger.start