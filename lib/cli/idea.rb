#coding:utf-8
require File.expand_path("../../idea",__FILE__)

opts = {}
args = ARGV
opts = eval(args[0]) if args.length > 0

idea = Ad::Idea.new(opts)
msg = idea.idea.strip
puts msg
