class Admin::LeaguesController < ApplicationController
  before_filter :authenticate

  # GET /admin/leagues
  # GET /admin/leagues.json
  def index
    @admin_leagues = League.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_leagues }
    end
  end

  # GET /admin/leagues/1
  # GET /admin/leagues/1.json
  def show
    @admin_league = League.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_league }
    end
  end

  # GET /admin/leagues/new
  # GET /admin/leagues/new.json
  def new
    @admin_league = League.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_league }
    end
  end

  # GET /admin/leagues/1/edit
  def edit
    @admin_league = League.find(params[:id])
  end

  # POST /admin/leagues
  # POST /admin/leagues.json
  def create
    @admin_league = League.new(params[:admin_league])

    respond_to do |format|
      if @admin_league.save
        format.html { redirect_to @admin_league, notice: 'League was successfully created.' }
        format.json { render json: @admin_league, status: :created, location: @admin_league }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_league.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/leagues/1
  # PUT /admin/leagues/1.json
  def update
    @admin_league = League.find(params[:id])

    respond_to do |format|
      if @admin_league.update_attributes(params[:admin_league])
        format.html { redirect_to @admin_league, notice: 'League was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/leagues/1
  # DELETE /admin/leagues/1.json
  def destroy
    @admin_league = League.find(params[:id])
    @admin_league.destroy

    respond_to do |format|
      format.html { redirect_to admin_leagues_url }
      format.json { head :no_content }
    end
  end
end
