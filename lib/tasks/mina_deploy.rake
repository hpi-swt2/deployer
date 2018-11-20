namespace :minadeploy do
  desc "it git pulls and calls mina:deploy"
  task :start, [:commit, :branch, :eventtype, :source, :path] => :environment do |task, args|
    args = args.to_hash
    user = `id -u -n`.chomp
    args[:source] = args[:source] || user
    puts "Arguments: #{args}"
    path = args.delete(:path){ "/home/#{user}/vm-portal" }
    system('git --version')
    success = system("git -C #{path} pull && #{path}/bin/bundle install && #{path}/bin/rails mina:deploy")
    Deployment.create(args.merge! 'success':success)
  end

  desc "it shows information on the last deploy attempt"
  task :latest => :environment do
    d = Deployment.last
    abort('ERROR: No deployments found!') if not d
    puts "#{d.success ? 'SUCCESS' : 'ERROR'} #{d.created_at} #{d.branch}@#{d.commit} via #{d.source} #{d.event_type}"
  end
end