class GistQuestionService

  #ACCESS_TOKEN = ENV['GITHUB_ACCESS_TOKEN'] || Rails.application.credentials.github[:access_token]

  def initialize(question, client: default_client)
    @question = question
    @test = @question.test
    @client = client
  end

  def call
    @client.create_gist(gist_params)
  end

  def success?
    @client.last_response.status == 201
  end

  private

  def default_client
    Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end

  def gist_params
    {
        "description": I18n.t('.gist_question_service.question_about',
                              test_title: @test.title),
        "public": false,
        "files": {
            "test_guru_question.txt": {
                "content": gist_content
            }
        }
    }
  end

  def gist_content
    content = [@question.body]
    content += @question.answers.pluck(:body)
    content.join("\n")
  end

end