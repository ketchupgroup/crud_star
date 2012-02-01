namespace :crud_star do
  
  namespace :user do
    
    desc "Creates a user for the admin panel"
    task :create => :environment do
      print "Enter user name: "
      username = STDIN.gets.strip
      
      password = ''
      while password.size < 8
        print "Enter password (minimum 8 characters): "
        password = STDIN.gets.strip
      end
      
      print "Enter name: "
      name = STDIN.gets.strip
      
      begin
        CrudStar::User.create!(:username => username, :password => password, :name => name)
        puts "User " + username + " created"
      rescue
        puts "Unable to create the user - check user name and password"
      end
      
    end
    
  end
end
