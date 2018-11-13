class ApplicationController < ActionController::API
  def deploy
    logger.info 'INFO: Processing deploy request'
    commit, branch = deploy_params[:commit], deploy_params[:branch]
    logger.info "INFO: Attempting to deploy commit '#{commit}', branch '#{branch}'"
    # https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#2xx_Success
    # 202 Accepted: The request has been accepted for processing, but the processing has not been completed. 
    head 202
  end

  def status
    render plain: "Deployer is running!"
  end

  private

    def deploy_params
      params.permit(:commit, :branch)
    end
end
