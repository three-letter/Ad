#coding:utf-8
require File.expand_path("../../config",__FILE__)

opts = {}
args = ARGV
opts = eval(args[0]) if args.length > 0

config = Ad::Config.new(opts)
rsp = config.submit
if rsp.include?("<html>")
	puts "提交配置成功"
else
	msg = rsp.match(/alert\('(.+?)'\)/)[1]
	puts msg
end