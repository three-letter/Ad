#coding:utf-8
require File.expand_path("../../cast",__FILE__)

opts = {}
args = ARGV
opts = eval(args[0]) if args.length > 0

cast = Ad::Cast.new(opts)
begin
	rsp = cast.cast
	puts rsp.body.strip
rescue
	puts "创建广告投放失败"
end
