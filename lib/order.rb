#coding: utf-8
require File.expand_path("../login",__FILE__)
require File.expand_path("../base",__FILE__)

module Ad

	# 广告订单类 处理订单的创建和删除
	class Order < Ad::Base
		include Ad::Login


		# 默认订单选项参数/值
		@@USER_NAME = "langhui"
		@@PWD = 123456
		@@DEFAULT_OPTIONS = {
			:buyingbrief_id              => "null",
			:order_type                  => "销售合同",
			:order_sub_type              => "北京",
			#:marcket_order_class         => "A",
			:need_gen_cast               => "-1",
			:customerName                => "欧莱雅      所属集团:欧莱雅集团",
			:customerid                  => "263",
			:agentName                   => "智威汤逊公司-华南      所属集团:WPP-群邑",
			:agentid                     => "337",
			:name                        => "欧莱雅-Ad-1",
			:quotation_version           => "20120101",
			:order_brand                 => "",
			:order_product               => "",
			:discount                    => 100,
			:cpm                         => "6",
			:start_date                  => Time.now.strftime("%Y-%m-%d"),
			:end_date                    => (Time.now + 60 * 60 * 24 * 3).strftime("%Y-%m-%d"),
			:direct_name                 => "",
			:order_direct_salsename      => -1,
			:channel_name                => "杜芸",
			:order_channel_salsename     => "83",
			:tp_name                     => "汪淼",
			:order_tp_salsename          => "397",
			:ae_name                     => "吕惠竹",
			:order_ae_salsename          => "161",
			:f_youku_company             => "P",
			:money                       => 100,
			:action											 => "#{Ad::Login::HOST}/order/action.jsp"
		}

		# 通过post创建订单
		# 默认的action为 http://10.10.221.40/order/action.jsp
		def create
			conn,headers = login
			post_url = URI.parse(@opts[:action])
			rsp = conn.post(post_url.path,@params,headers)
			msg = rsp.body.to_s.strip.force_encoding("UTF-8")
			message,id = msg,order_id
		end
		
		# 创建订单成功后 根据name获取order_id
		def order_id
			conn,headers = login
			doc = conn.get("/order/OrderList.jsp",headers).body
			doc = doc.force_encoding("UTF-8")
			doc.match(/<td rowno="(\d+)">\s+\d+\s+<\/td>\s+<td>.+?#{@opts[:name]}/)[1]	if doc =~ /<td rowno="\d+">\s+\d+\s+<\/td>\s+<td>.+?#{@opts[:name]}/
		end	

		# 提交订单
		def submit order_id
			conn,headers = login
			conn.get("/OrderProductCommitServlet?order_id=#{order_id}&product_id=1&money=#{@opts[:money]}",headers)
		end

	end

end

