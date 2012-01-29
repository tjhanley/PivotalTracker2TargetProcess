$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'../lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'../config'))

require 'rubygems'
require 'httparty'
require 'target_process'
require 'conf'

# puts CONFIG.inspect