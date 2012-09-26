#coding:utf-8
require File.expand_path("../../order",__FILE__)

opts = {}
args = ARGV
opts = eval(args[0]) if args.length > 0

order = Ad::Order.new(opts)
msg, order_id = order.create
unless msg == "操作成功"
	puts msg
else
	order.submit(order_id)
	puts "Order_id: #{order_id}"
end

