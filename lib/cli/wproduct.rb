#coding:utf-8
require File.expand_path("../../wproduct",__FILE__)

opts = {}
args = ARGV
opts = eval(args[0]) if args.length > 0

pro = Ad::WProduct.new(opts)
msg = pro.set
conf = pro.config
puts msg
conf.keys.each {|key| puts "order_id: #{opts[:order_id]}  config_id: #{key}  config_name: #{conf[key]}"}
