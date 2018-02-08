module GetFBData
  require 'koala'
  require 'pp'
  def gets_data
    graph = Koala::Facebook::API.new(@access_token)
    graph_result = graph.get_connection('me', 'posts', { fields: %w(place created_time) } )
    @results = graph_result.to_a
    until (next_results = graph_result.next_page).nil?
      @results += next_results.to_a
      graph_result = next_results
    end
     @results
  end

  def filter_by_date(since_time, until_time)
    gets_data
    @since_time = Time.parse(since_time)
    @until_time = Time.parse(until_time)
    @results.select do |di|
      !di['place'].nil? && Time.parse(di['created_time']).between?(@since_time, @until_time)
    end.map do |di|
      di['place']['name'] = 'NO NAME' if di['place']['name'] == ''
      {
        time: di['created_time'],
        name: di['place']['name'],
        lat: di['place']['location']['latitude'],
        lng: di['place']['location']['longitude']
      }
    end
  end
end
