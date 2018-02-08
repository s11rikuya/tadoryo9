module GetFBData
  require 'koala'
  require 'pp'
  def gets_data
    graph = Koala::Facebook::API.new(@access_token)
    graph_result = graph.get_connection('me', 'posts', { fields: %w(place created_time) } )
    results = graph_result.to_a
    until (next_results = graph_result.next_page).nil?
      results += next_results.to_a
      graph_result = next_results
    end
    pp results
    return results
  end

  def filter(data_indexs)
    data_indexs.select do |di|
      !di['place'].nil? && Time.parse(di['created_time']).between?(@from_time, @to_time)
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
