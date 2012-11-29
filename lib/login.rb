#coding:utf-8
require 'net/http'

module Ad
	module Login
		HOST = "http://10.10.221.40"
		@@login_url = "#{HOST}/login_action1.0.jsp" 
		@@user = "langhui"
		@@pwd  = 123456
		# 用户登陆返回conn和包含cookie的头信息
		# 用于访问该host下有权限限制的path
		def login
			url = URI.parse(@@login_url)
			conn = Net::HTTP.new(url.host,url.port)
			data = "username=#{@@user}&password=#{@@pwd}"
			rsp = conn.post(url.path,data,{})
			cookie = rsp.response['set-cookie']
			headers = {
				'Content-Type' => "application/x-www-form-urlencoded; charset=UTF-8",
				'Referer' => "#{HOST}/order/createOrUpdateAdd.jsp",
				'Cookie' => cookie
			}
			c,h = conn,headers
		end
		
	end
end

