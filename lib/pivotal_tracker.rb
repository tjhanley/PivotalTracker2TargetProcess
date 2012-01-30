class PivotalTracker
    require 'hashie'
    include HTTParty
    base_uri 'https://www.pivotaltracker.com/services/v3/projects/{your id}'
    default_params :token => '{your api token}'

    def initialize
        puts "PT initialized..."    
    end

    def project(options={})
        self.class.get("/", options).to_hash['project']
    end

    def stories(options={})
        self.class.get("/stories?", options).to_hash['stories']
    end

    def story(id=0)
        self.class.get("/stories/#{id}").to_hash['story']
    end

end