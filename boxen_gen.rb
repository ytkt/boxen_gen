require 'open-uri'
require 'nokogiri'
require 'erb'

def repolist
  doc = Nokogiri::HTML( open('https://github.com/boxen') )
  repos = []
  doc.css('ul.repolist > li').each do |li|
    repo = li.css('h3.repolist-name a').text
    repos << repo.gsub('puppet-', '') if repo =~ /puppet-/
  end

  return repos
end

def installed_apps
  apps = `ls /Applications/`.split("\n")
  apps.delete_if { |app|
    app !~ /.app/
  }.map! { |app|
    app.gsub!('.app', '')
    app = app.downcase
  }
end

def matched_list
  matched = []
  repolist.each do |repo|
    matched << repo if installed_apps.include?(repo)
  end

  return matched
end

def brew_list
  list = `brew list`.split("\n")
end

print 'username: '
username = STDIN.gets.gsub("\n", "")

template = File.read("people.pp.erb", :encoding => Encoding::UTF_8)
erb = ERB.new(template)
File.open("#{username}.pp", "w") do |output|
  output.write erb.result(binding)
end

#matched_list
#brew_list
