class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :authenticate_user!
  before_action :set_all_languages

  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.all
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
    @matches = Match.all
    @possible_matches = Match.possible_for @user
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(requested_by: params[:match][:user].to_i, confirmed: false)
    @match_language1 = MatchLanguage.create!(
      match: @match,
      language_id: params[:match][:teacher_language].to_i,
      teacher_id: params[:match][:user].to_i,
      student_id: params[:match][:other_user].to_i
      )
    @match_language2 = MatchLanguage.create!(
      match: @match,
      language_id: params[:match][:student_language].to_i,
      teacher_id: params[:match][:other_user].to_i,
      student_id: params[:match][:user].to_i
      )
    @match_user1 = MatchUser.create!(
      match: @match,
      user_id: params[:match][:user].to_i
      )
    @match_user2 = MatchUser.create!(
      match: @match,
      user_id: params[:match][:other_user].to_i
      )
    respond_to do |format|
      if @match.save && @match_language1.save && @match_language2.save && @match_user1.save && @match_user2.save
        format.html { redirect_to "/profile", notice: 'Match was successfully created.' }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def confirm
    match = Match.find(params[:id])
    match.confirmed = true

    if match.save
      redirect_to "/profile"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:from, :to, :other_user, :teacher_language, :student_language)
    end

    def set_user
      @user = current_user
    end

    def set_all_languages
      @all_languages = Language.all
    end
  end
