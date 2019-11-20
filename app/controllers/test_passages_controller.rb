class TestPassagesController < ApplicationController
  before_action :set_test_passage, only: %i[show update result gist]

  def show; end

  def result; end

  def gist
    gist_service = GistQuestionService.new(@test_passage.current_question)
    result = gist_service.call
    gist_url = result.html_url

    if gist_service.success?
      Gist.create(user_id: current_user.id,
                  question_id: @test_passage.current_question.id,
                  url: gist_url)
      flash[:notice] = "#{t('.success')} #{view_context.link_to gist_url.to_s, gist_url, target: '_blank'}"
    else
      flash[:alert] = t('.failure')
    end

    redirect_to @test_passage
  end

  def update
    @test_passage.accept!(params[:answer_ids])

    if @test_passage.completed?
      TestsMailer.completed_test(@test_passage).deliver_now
      redirect_to result_test_passage_path(@test_passage)
    else
      render :show
    end
  end

  private

  def set_test_passage
    @test_passage = TestPassage.find(params[:id])
  end
end