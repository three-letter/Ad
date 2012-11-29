#coding:utf-8
require File.expand_path("../../submit",__FILE__)

opts = {}
args = ARGV
opts = eval(args[0]) if args.length > 0

sub = Ad::Submit.new(opts)
msg = sub.submit
puts msg
