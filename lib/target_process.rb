class TargetProcess
    require 'hashie'
    require 'json'

    include HTTParty
    # debug_output
    base_uri 'https://tp-url/'
    default_params :resultFormat => :json
    basic_auth 'username', 'password'

    def initialize(init={})
        puts "TP initialized..."
    end

    def all_stories(options={})
        options.merge!({})
        self.class.get("/api/v1/UserStories/", options)
    end

    def get_context(options={})
        options.merge!({})
        resp = self.class.get("/api/v1/Context/", options).to_hash
        resp['Context']
    end

    def create_user_story(payload={})
        Hashie::Mash.new(self.class.post('/api/v1/UserStories/', 
                               :body => "#{payload.to_json}", 
                               :headers => {"Content-Type" => 
                                   'application/json'})).to_hash
    end

    def create_bug(payload={})
        Hashie::Mash.new(self.class.post('/api/v1/Bugs/', 
                               :body => "#{payload.to_json}", 
                               :headers => {"Content-Type" => 
                                   'application/json'})).to_hash
    end

end