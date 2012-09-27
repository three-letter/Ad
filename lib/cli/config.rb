#coding:utf-8
require File.expand_path("../../config",__FILE__)
require File.expand_path("../../product",__FILE__)

opts = {}
args = ARGV
opts = eval(args[0]) if args.length > 0

config = Ad::Config.new(opts)
rsp = config.submit
if rsp.include?("<html>")
	puts "提交配置成功"
	# 更改配置后原config_id会变,故再显示全部的配置信息
	pro = Ad::Product.new(opts)
	conf = pro.config
	conf.keys.each {|key| puts "order_id: #{opts[:order_id]}  config_id: #{key}  config_name: #{conf[key]}"}
else
	msg = rsp.match(/alert\('(.+?)'\)/)[1]
	puts msg
end
