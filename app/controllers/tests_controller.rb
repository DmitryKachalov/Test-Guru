class TestsController < ApplicationController
  before_action :find_test, only: %i[show]
  after_action :send_log_message
  around_action :log_execute_time

  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_test_not_found
  #render plain: 'All tests'
  # /tests?level=2&lang=ru
  # /tests?data%5Blevel%5D=2&data%5Blang%5D=ru

  def index
    #render json: { tests: Test.all }
    #render file: 'public/hello'


    #head :no_content

     #byebug
    #render inline: '<%= console %>'
    #logger.info(self.object_id)
    #respond_to do |format|
     # format.html { render plain: 'All tests'}
      #format.json { render json: { tests: Test.all } }
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")

  end

  def show
    #title = Test.first.title
    render inline: '<%= @test.title %>'
    #redirect_to root_path
  end

 #def new

  #end
  #def create
    #result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    #render plain: result.join("\n")

    #test = Test.create(test_params)

    #render plain: test.inspect
  #end

  private

  def find_test
    @test = Test.find(params[:id])
  end
  #def test_params
    #params.require(:test).permit(:title, :level)
  #end
  def send_log_message
    logger.info("Action [#{action_name}] was finished")
  end

  def log_execute_time
    start = Time.now
    yield
    finish = Time.now - start

    logger.info("Execution time: #{finish * 1000}ms")
  end

  def rescue_with_test_not_found
    render plain: 'Test was not found'
  end
end

