$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'../lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'../config'))

require 'rubygems'
require 'httparty'
require 'target_process'
require 'pivotal_tracker'
require 'conf'
require 'pp'
require 'lesstile'

# settings
@project = nil
P_ID = CONFIG[:target_process][:project_id]
ENTITIES = { 'bug' => 'Bug', 
             'feature' => 'UserStory' 
}
STATES = { 'accepted' => 'Done', 
            'unscheduled' => 'Open',
            'delivered' => 'Ready For QA',
            'started' => 'In Progress',
            'unstarted' => 'Open'
}

# inits
tp_client = TargetProcess.new({:username => CONFIG[:target_process][:uname],
                       :password => CONFIG[:target_process][:pwd]})
pt_client = PivotalTracker.new

id_arr = []
File.open(File.join(File.dirname(__FILE__), '../config/ids.rb'), "r").each{ |line|
    id_arr.push(line)
}

# execute
project = pt_client.project
puts "Pivotal Tracker Project: #{project['name']}"

stories = pt_client.stories

puts "#{stories.count} stories in project"

stories.each do |story|
    unless id_arr.include?("#{story['id']}\n")
        puts story["name"]
        # pp story
        puts "========================="
        desc = "Requested By: #{story['requested_by']}\n"
        desc << "#{story['description']}\n\n" if story['description'] != nil

        if story['notes'] && story['notes'].size > 0
            desc << "Notes:\n"
            desc << "=============================\n"
            story['notes'].each do |note| 
                    desc << "\t#{note['author']} - #{note['noted_at']}\n"
                    desc << "\t#{note['text']}\n"
            end
        end
        if story['attachments'] && story['attachments'].size > 0
            desc << "Attachments:\n"
            desc << "=============================\n"
            story['attachments'].each do |attachment|
                desc << "\"#{attachment['filename']}\":#{attachment['url']}\n"
            end
        end
        desc << "\nImported from Pivotal Tracker\n"
        desc << "\"#{story['url']}\":#{story['url']}\n"
        desc << "Lables: #{story['labels']}\n"

        tags = story['labels']
        tags = "#{story['labels']}, PT-#{story['current_state']}"

        payload = { 'Project' => {'Id' => P_ID},
                    'Name' => story['name'],
                    'Description' => Lesstile.format_as_html(desc),
                    'Tags' => tags
                }
        # exit
        if ENTITIES[story['story_type']] == 'Bug'
            resp = tp_client.create_bug(payload)
        else
            resp = tp_client.create_user_story(payload)
        end
        id_arr.push(story['id'])
        # pp id_arr
        File.open(
            File.join(
                File.dirname(__FILE__),
            '../config/ids.rb'),
        "a+") do |f|
            f.puts story['id']
        end
        # file.write("#{story['id']}")
    else
        puts "Already Got This One"
    end #unless
end

# junk below...

# story = pt_client.story(19043031)
    
# puts story["name"]
# pp story
# # exit
# puts "========================="
# desc = "Requested By: #{story['requested_by']}\n"
# desc << "#{story['description']}\n\n" if story['description'] != nil

# if story['notes'] && story['notes'].size > 0
#     desc << "Notes:\n"
#     desc << "=============================\n"
#     story['notes'].each do |note| 
#             desc << "\t#{note['author']} - #{note['noted_at']}\n"
#             desc << "\t#{note['text']}\n"
#     end
# end
# if story['attachments'] && story['attachments'].size > 0
#     desc << "Attachments:\n"
#     desc << "=============================\n"
#     story['attachments'].each do |attachment|
#         desc << "\"#{attachment['filename']}\":#{attachment['url']}\n"
#     end
# end
# desc << "\nImported from Pivotal Tracker\n"
# desc << "\"#{story['url']}\":#{story['url']}\n"
# desc << "Lables: #{story['labels']}\n"

# payload = { 'Project' => {'Id' => P_ID},
#             'Name' => story['name'],
#             'Description' => Lesstile.format_as_html(desc),
#             'Tags' => story['labels']
#         }
# # exit
# if ENTITIES[story['story_type']] == 'Bug'
#     resp = tp_client.create_bug(payload)
# else
#     resp = tp_client.create_user_story(payload)
# end
# pp resp





# PivotalTracker::Client.token = CONFIG[:pivotal_tracker][:api_token]
# projects = PivotalTracker::Project.all

# projects.each do |p|
#     @project = p if p.id == CONFIG[:pivotal_tracker][:project_id]
# end

# exit if !@project

# puts "PivotalTracker Project: #{@project.name}"

# stories = @project.stories.all

# puts "#{stories.inspect} stories in this project"



# pt_project = PivotalTracker::Project.find(CONFIG[:pivotal_tracker][:project_id]) 

# pp @projects

# stories = tp.all_stories
# puts "Story Count: #{stories.inspect}"

# acid = tp_client.get_context({:ids => "#{P_ID},745"})['Acid']
# puts acid

