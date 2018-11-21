namespace :minadeploy do
  desc "it git pulls and calls mina:deploy"
  task :start, [:commit, :branch, :event_type, :source, :path] => :environment do |task, args|
    args = args.to_hash
    user = `id -u -n`.chomp
    args[:source] = args[:source] || user
    puts "Arguments: #{args}"
    path = args.delete(:path){ "/home/#{user}/vm-portal" }
    system('git --version')
    environment = 'not_set'
    environment = 'production' if args[:branch] == 'master'
    environment = 'staging' if args[:branch] == 'dev'
    command = "(cd #{path} && git pull && bundle install && mina #{environment} deploy) 2>&1"
    output = `#{command}`
    result=$?.success?
    Deployment.create(args.merge! success: result, log: "$ #{command}\n\n #{output}")
    byebug
  end

  desc "it shows information on the last deploy attempt"
  task :latest => :environment do
    d = Deployment.last
    abort('ERROR: No deployments found!') if not d
    puts "#{d.success ? 'SUCCESS' : 'ERROR'} #{d.created_at} #{d.branch}@#{d.commit} via #{d.source} #{d.event_type}"
  end
end