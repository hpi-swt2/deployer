require 'rake'

Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
DeploymentApp::Application.load_tasks # providing your application name is 'sample'

class MainController < ApplicationController
  def deploy
    fork do
      Rake::Task["minadeploy:start"].reenable # in case you're going to invoke the same task second time.
      Rake::Task["minadeploy:start"].invoke(deploy_params[:commit],
                                            deploy_params[:branch],
                                            deploy_params[:eventtype],
                                            request[:original_url],
                                            deploy_params[:simulate])
    end

    # https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#2xx_Success
    # 202 Accepted: The request has been accepted for processing, but the processing has not been completed.
    head 202
  end

  def index
    @deployments = Deployment.all.order(created_at: :desc)
  end

  private

    def deploy_params
      params.permit(:commit, :branch, :eventtype, :simulate)
    end
end
