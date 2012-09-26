#coding:utf-8
require File.expand_path("../../scheduled",__FILE__)

opts = {}
args = ARGV
opts = eval(args[0]) if args.length > 0

sch = Ad::Scheduled.new(opts)
msg = sch.scheduled
msg = "预定成功" if msg.empty?
puts msg
