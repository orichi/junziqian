# Junziqian

Junziqian is an electronic sign contract system. This gem is an adaptor for interactive with junziqian's service.

君子签是电子签章的一种，上传签约人，签约合同，实现电子签章或手工签约，并在三方保存，以符合一定的法律效力。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'junziqian'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install junziqian

## Usage

* 首先设置您的接口信息，包含请求地址，key，secret，gem通过 ENV 变量获取三个参数; 合同下载存放路径 ENV['contract_path'] (默认为/tmp)
````
    def services_url
      ENV['JZQ_SERVICES_URL'] || 'http://sandbox.api.junziqian.com/services'
    end

    def app_key
      ENV['JZQ_APP_KEY'] || 'ecf3961459a07af4'
    end

    def app_secret
      ENV['JZQ_APP_SECRET'] || '187a255fecf3961459a07af4d2035e47'
    end
````
* 实现ping接口检测、文件上传签约、状态查询、查看链接、下载链接等等的功能，具体请看lib/junziqian/interface目录

* 回调参数校验
````
    body_hash = {
        'applyNo' => params[:applyNo],
        'identityType' => params[:identityType],
        'fullName' => params[:fullName],
        'identityCard' => params[:identityCard],
        'optTime' => params[:optTime],
        'signStatus' => params[:signStatus]
    }
    if params[:sign] == Junziqian::Tool::RequestTool.create_http_sign(body_hash, params[:timestamp])
      ...
    ...  
````    
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/junziqian.

