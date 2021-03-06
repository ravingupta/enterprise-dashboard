class ConversionController < ApplicationController

  get '/graphdata' do
    start_time = Time.parse(params[:startTime])
    end_time = Time.parse(params[:endTime])
    graph_type = params[:graph_type].to_i

    enterprise = get_enterprise

    conversionData = Octo::Conversions.data( enterprise.id, graph_type, start_time..end_time)
    json_arr = conversionData.inject([]) do |arr, conv|
      arr << { ts: conv.ts, value: conv.value }
      arr
    end
    {data: json_arr}.to_json
  end

  get '/:type' do
    @type = nil
    @title = nil
    @breadcrumb = nil

    case params[:type]
    when 'newsfeed'
      @type = Octo::Conversions::NEWSFEED
      @title = 'Newsfeed Conversions'
      @breadcrumb = 'feed'
    when 'notification'
      @type = Octo::Conversions::PUSH_NOTIFICATION
      @title = 'Push Notification Conversions'
      @breadcrumb = 'notification'
    when 'email'
      @type = Octo::Conversions::EMAIL
      puts 'currently not working on this'
      @title = 'Email Conversions'
      @breadcrumb = 'email'
    else
      @type = nil
      puts 'no match found'
    end

    erb :feed_conversion
  end

end
