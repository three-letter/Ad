#coding:utf-8
require File.expand_path("../../order",__FILE__)
require File.expand_path("../../product",__FILE__)
require File.expand_path("../../wproduct",__FILE__)
require File.expand_path("../../config",__FILE__)
require File.expand_path("../../scheduled",__FILE__)
require File.expand_path("../../cast",__FILE__)
require File.expand_path("../../idea",__FILE__)
require File.expand_path("../../submit",__FILE__)

=begin
	广告投放测试数据生成的快捷脚本
	具体可分为以下步骤: order product config scheduled cast idea submit
	大部分参数是采用默认值,其中部分需要人工输入
	order: name order_type   product: device   config: cpm  scheduled: date type  idea: name idea_url
	example
	./ad shortcut '{ :order => { :name => "test-shortcut-ad-1", :order_type => "市场合同"}, :product => { :device => "w"}, :config => {:cpm => 6 }, :scheduled => { :date => "2010-11-30", :type => 1}, :idea => { :name => "test-idea-1", :idea_url => "http://v.youku.com/v_show/id_XNDc4NTE5Njk2.html"}  }'
=end


PATH = File.expand_path("..", __FILE__)

def error_process msg
	puts "#{msg}"
	Process.exit
end

def get_msg
	msg = []
	File.open("#{PATH}/info.txt", "r") do |f|
		while line = f.gets
			msg << line if line && !line.empty?
		end
	end
	msg
end


begin
	args = ARGV
	error_process("缺失必要的参数") if !args || args.length == 0
	opts = eval(args[0])
	error_process("缺失必要的参数") if opts.nil? 
	# create order
	error_process("缺失order必要的参数") unless opts[:order]
	order_opts = opts[:order]
	system "ruby #{PATH}/order.rb '#{order_opts}' > #{PATH}/info.txt"
	order_msg = get_msg
	order_id = order_msg[0].match(/Order_id:\s+(\d+)/)[1]
	order_params = { :order_id => order_id.to_i }
	# set product
	order_params = order_params.merge(opts[:product]) if opts[:product]
	device = order_params[:device]
	order_params.delete(:device)
	device = "" if device.nil? || device == "p"
	system "ruby #{PATH}/#{device}product.rb '#{order_params}' > #{PATH}/info.txt"
	product_msg = get_msg
	config_id = product_msg[1].match(/config_id:\s+(\d+)/)[1]
	product_name = product_msg[1].match(/config_name:\s+(.+)/)[1]
	product_params = { :order_id => order_id, :config_id => config_id,  :name =>product_name, :device => device.empty?? "p":"w"}
	# finish config
	product_params = product_params.merge(opts[:config]) if opts[:config]
	system "ruby #{PATH}/config.rb '#{product_params}' > #{PATH}/info.txt"
	config_msg = get_msg
	# scheduled date
	product_params = product_params.merge(opts[:scheduled]) if opts[:scheduled]
	product_params.delete(:name)
	system "ruby #{PATH}/scheduled.rb '#{product_params}' > #{PATH}/info.txt"
	# save cast
	castparams = {:order_id => order_id}.merge(opts[:cast]) if opts[:cast]
	system "ruby #{PATH}/cast.rb '#{castparams}' > #{PATH}/info.txt"
	cast_msg = get_msg
	id = cast_msg[0].match(/(\d+)_/)[1]
	cast_params = { :id => id }
	# add idea
	cast_params = cast_params.merge(opts[:idea]) if opts[:idea]
	system "ruby #{PATH}/idea.rb '#{cast_params}' > #{PATH}/info.txt"
	# submit ad
	system "ruby #{PATH}/submit.rb '{:id => #{id}}' > #{PATH}/info.txt"
	# update db
	system "ruby #{PATH}/db.rb '{:id => #{id}}'"
rescue
ensure
	puts get_msg
end
