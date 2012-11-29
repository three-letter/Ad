#coding: utf-8
require File.expand_path("../login",__FILE__)
require File.expand_path("../base",__FILE__)

module Ad
	# 订单的产品预订模块
	class WProduct < Ad::Base
		include Ad::Login

		# 默认产品选项参数/值
		@@DEFAULT_OPTIONS = {
			:config_id        => "null",
			:desc             => "",
			:order_id         => 0,
			:product_id       => 1,
			:time             => [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],
			:time_check_all   => "radiobutton",
			:action           => "#{Ad::Login::HOST}/vp/wConfigActionAdd.sdo"
		}
		
		# 设置产品信息，包括：类型 地区 时间等
		def set
			conn,headers = login
			post_url = URI.parse(@opts[:action])
			rsp = conn.post(post_url.path,@params,headers)
			msg = rsp.body.to_s.strip
			msg.match(/alert\('(.+?)'\)/)[1]
		end
		
		# 获取产品配置信息：ID 名称
		def config
			conn,headers = login
			doc = conn.get("/vp/vp_config_list.jsp?order_id=#{@opts[:order_id]}&product_id=1",headers).body
			doc = doc.force_encoding("UTF-8")
			config_id,config_name = [], []
			config_ids = doc.scan(/<TD>(\d+)<\/TD>/)
			config_names = doc.scan(/name=name\s+value='(.+)'/)
			config_ids.each {|conf| config_id << conf.join}
			config_names.each {|conf| config_name << conf.join}
			Hash[config_id.zip(config_name)]
		end
		
	end
end
