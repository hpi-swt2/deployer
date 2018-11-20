require 'rake'

Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
DeploymentApp::Application.load_tasks # providing your application name is 'sample'

class MainController < ApplicationController
  def deploy
    deploy_params.merge! 'source': request.original_url

    fork do
      Rake::Task["minadeploy:start"].reenable # in case you're going to invoke the same task second time.
      Rake::Task["minadeploy:start"].invoke(*deploy_params)
    end

    # https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#2xx_Success
    # 202 Accepted: The request has been accepted for processing, but the processing has not been completed.
    head 202
  end

  def index
  end

  private

    def deploy_params
      params.permit(:commit, :branch, :eventtype)
    end
end
