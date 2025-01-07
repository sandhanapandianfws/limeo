Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: 'http://3.211.105.77:9200',
  # ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200',
  user: 'elastic',
  # ENV['ELASTICSEARCH_USERNAME'],
  password: 'uhSyxXgvK5Rug7c=eMq3',
  # ENV['ELASTICSEARCH_PASSWORD'],
  log: true
)
